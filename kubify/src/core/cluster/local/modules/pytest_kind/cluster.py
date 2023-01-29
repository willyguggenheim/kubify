import logging
import os
import platform
import random
import socket
import subprocess
import time
from contextlib import contextmanager
from pathlib import Path
from typing import Generator
from typing import Optional
from typing import Union

import pykube
import requests


KIND_VERSION = os.environ.get("KIND_VERSION", "v0.17.0")
KUBECTL_VERSION = os.environ.get("KUBECTL_VERSION", "v1.25.3")


class KindCluster:
    def __init__(
        self,
        name: str,
        kubeconfig: Optional[Path] = None,
        image: Optional[str] = None,
        kind_path: Optional[Path] = None,
        kubectl_path: Optional[Path] = None,
    ):
        self.name = name
        self.image = image
        path = Path(".pytest-kind")
        self.path = path / name
        self.path.mkdir(parents=True, exist_ok=True)
        self.kubeconfig_path = kubeconfig or (self.path / "kubeconfig")
        self.kind_path = kind_path or (self.path / f"kind-{KIND_VERSION}")
        self.platform = platform.system().lower()
        if self.platform == "windows":
            self.kubectl_path = kubectl_path or (
                self.path / f"kubectl-{KUBECTL_VERSION}.exe"
            )
        else:
            self.kubectl_path = kubectl_path or (
                self.path / f"kubectl-{KUBECTL_VERSION}"
            )

    def ensure_kind(self):
        if not self.kind_path.exists():
            url = os.getenv(
                "KIND_DOWNLOAD_URL",
                f"https://github.com/kubernetes-sigs/kind/releases/download/{KIND_VERSION}/kind-{self.platform}-amd64",
            )
            logging.info(f"Downloading {url}..")
            tmp_file = self.kind_path.with_suffix(".tmp")
            with requests.get(url, stream=True) as r:
                r.raise_for_status()
                with tmp_file.open("wb") as fd:
                    for chunk in r.iter_content(chunk_size=8192):
                        if chunk:
                            fd.write(chunk)
            tmp_file.chmod(0o755)
            tmp_file.rename(self.kind_path)

    def ensure_kubectl(self):
        if not self.kubectl_path.exists():
            if self.platform == "windows":
                url = os.getenv(
                    "KUBECTL_DOWNLOAD_URL",
                    f"https://dl.k8s.io/release/{KUBECTL_VERSION}/bin/{self.platform}/amd64/kubectl.exe",
                )
            else:
                url = os.getenv(
                    "KUBECTL_DOWNLOAD_URL",
                    f"https://dl.k8s.io/release/{KUBECTL_VERSION}/bin/{self.platform}/amd64/kubectl",
                )
            logging.info(f"Downloading {url}..")
            tmp_file = self.kubectl_path.with_suffix(".tmp")
            with requests.get(url, stream=True) as r:
                r.raise_for_status()
                with tmp_file.open("wb") as fd:
                    for chunk in r.iter_content(chunk_size=8192):
                        if chunk:
                            fd.write(chunk)
            tmp_file.chmod(0o755)
            tmp_file.rename(self.kubectl_path)

    def create(self, config_file: Optional[Union[str, Path]] = None):
        """Create the kind cluster if it does not exist (otherwise re-use)."""
        self.ensure_kind()

        self.kubeconfig_path.touch(0o600, exist_ok=True)

        cluster_exists = False

        while not cluster_exists:
            out = subprocess.check_output(
                [str(self.kind_path), "get", "clusters"], encoding="utf-8"
            )
            for name in out.splitlines():
                if name == self.name:
                    cluster_exists = True

            if not cluster_exists:
                create_cmd = [
                    str(self.kind_path),
                    "create",
                    "cluster",
                    f"--name={self.name}",
                    f"--kubeconfig={self.kubeconfig_path}",
                ]

                if self.image:
                    create_cmd += [
                        f"--image={self.image}",
                    ]

                if config_file:
                    create_cmd += ["--config", str(config_file)]

                logging.info(f"Creating cluster {self.name}..")
                subprocess.run(create_cmd, check=True)
                cluster_exists = True

            if not self.kubeconfig_path.exists():
                self.delete()
                cluster_exists = False

        config = pykube.KubeConfig.from_file(self.kubeconfig_path)
        self.api = pykube.HTTPClient(config)

    def load_docker_image(self, docker_image: str):
        logging.info(f"Loading Docker image {docker_image} in cluster (usually ~5s)..")
        subprocess.run(
            [
                str(self.kind_path),
                "load",
                "docker-image",
                "--name",
                self.name,
                docker_image,
            ],
            check=True,
        )

    def kubectl(self, *args: str, **kwargs) -> str:
        """Run a kubectl command against the cluster and return the output as string."""
        self.ensure_kubectl()
        return subprocess.check_output(
            [str(self.kubectl_path), *args],
            env={**os.environ, "KUBECONFIG": str(self.kubeconfig_path)},
            encoding="utf-8",
            **kwargs,
        )

    @contextmanager
    def port_forward(
        self,
        service_or_pod_name: str,
        remote_port: int,
        *args,
        local_port: Optional[int] = None,
        retries: int = 10,
    ) -> Generator[int, None, None]:
        """Run "kubectl port-forward" for the given service/pod and use a random local port."""
        port_to_use: int
        proc = None
        for i in range(retries):
            if proc:
                proc.kill()
            # Linux epheremal port range starts at 32k
            port_to_use = local_port or random.randrange(5000, 30000)
            proc = subprocess.Popen(
                [
                    str(self.kubectl_path),
                    "port-forward",
                    service_or_pod_name,
                    f"{port_to_use}:{remote_port}",
                    *args,
                ],
                env={"KUBECONFIG": str(self.kubeconfig_path)},
            )
            time.sleep(1)
            returncode = proc.poll()
            if returncode is not None:
                if i >= retries - 1:
                    raise Exception(
                        f"kubectl port-forward returned exit code {returncode}"
                    )
                else:
                    # try again
                    continue
            s = socket.socket()
            try:
                s.connect(("127.0.0.1", port_to_use))
            except:
                if i >= retries - 1:
                    raise
            finally:
                s.close()
        try:
            yield port_to_use
        finally:
            if proc:
                proc.kill()

    def delete(self):
        """Delete the kind cluster ("kind delete cluster")."""
        logging.info(f"Deleting cluster {self.name}..")
        subprocess.run(
            [
                str(self.kind_path),
                "delete",
                "cluster",
                f"--name={self.name}",
                f"--kubeconfig={self.kubeconfig_path}",
            ],
            check=True,
        )
