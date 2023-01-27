from pathlib import Path

import kubify.src.core.app_constants as app_constants
from pytest_kind import KindCluster


class Up:
    def __init__(self):
        pass

    def up(self):
        deployment_manifest_yaml = f"""
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
  - hostPath: "{app_constants.root_dir_full_path}"
    containerPath: /var/folders/kubify
    readOnly: true
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 8200
    protocol: TCP
  - containerPort: 443
    hostPort: 8443
    protocol: TCP
"""
        kind_yaml = f"{app_constants.kubify_work}/kind.yaml"
        kind_yaml_path = Path(kind_yaml)
        kind_yaml_path.touch(exist_ok=True)
        with open(kind_yaml_path, "w+") as file:
            file.write(deployment_manifest_yaml)
        kind_cluster = KindCluster(name="kubify")
        kind_cluster.create(config_file=kind_yaml)
        kind_cluster.kubectl(
            "apply",
            "-f",
            f"{app_constants.git_dir}/../kubify/ops/templates/k8s/bootstrap.yaml",
        )

    def main(self):
        self.up()


if __name__ == "__main__":
    up = Up()
    up.main()
