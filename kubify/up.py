#!/bin/python3

import os
from pathlib import Path

import kubify.src.kubify
import kubify.src.core.app_constants as app_constants
from pytest_kind import KindCluster


class Up:
    def __init__(self):
        pass

    def up(self):
        print("💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻👩‍💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻")
        print(
            "...................😎 Installing or Re-Installing Kubify 😎..................."
        )
        print("💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻")
        deployment_manifest_yaml = f"""
            kind: Cluster
            apiVersion: kind.x-k8s.io/v1alpha4
            nodes:
            - role: control-plane
            extraMounts:
            - hostPath: "{app_constants.cwd}"
                containerPath: /src/kubify
                readOnly: false
            - hostPath: "{app_constants.home}/.aws"
                containerPath: /root/.aws
                readOnly: false
            - hostPath: "{app_constants.home}/.ssh"
                containerPath: /root/.ssh
                readOnly: false
            - hostPath: /var/run/docker.sock
                containerPath: /var/run/docker.sock
                propagation: HostToContainer
                readOnly: false
            kubeadmConfigPatches:
            - |
                kind: InitConfiguration
                nodeRegistration:
                kubeletExtraArgs:
                    node-labels: "ingress-ready=true"
            extraPortMappings:
            - containerPort: 80
                hostPort: 80
                protocol: TCP
            - containerPort: 443
                hostPort: 443
                protocol: TCP
        """
        kind_yaml = f"{app_constants.kubify_work}/kind.yaml"
        kind_yaml_path = Path(kind_yaml)
        kind_yaml_path.touch(exist_ok=True)
        with open(kind_yaml_path, "w+") as file:
            file.write(deployment_manifest_yaml)
        cluster = KindCluster("kind")
        cluster.create()
        cluster.kubectl("apply", "-f", kind_yaml)

    def main(self):
        self.up()


if __name__ == "__main__":
    up = Up()
    up.main()
