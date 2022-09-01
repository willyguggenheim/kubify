#!/bin/python3

import kubify.src.core.cluster.local.kind as kind
import kubify.src.core.app_constants as app_constants


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
            - hostPath: "${WORK_DIR}/certs"
                containerPath: /usr/local/certificates
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
        kind.create_namespaced_deployment(
            deployment_name="kind",
            deployment_manifest=deployment_manifest_yaml,
            namspace="default",
        )

    def main(self):
        self.up()


if __name__ == "__main__":
    up = Up()
    up.main()
