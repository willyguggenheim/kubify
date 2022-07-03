#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

which eksctl || brew install eksctl

#####
## Covers KMS Keys
#####

# ........

# TODO: terraform apply (for KMS Keys)

# ........

#####
## Covers "eks" folder: Deploy/Update Clusters:
#####

# ........

# CPU CLUSTERS:
##

# West (HA us-west-2 dev MAIN) cluster deployments:
export AWS_DEFAULT_REGION=us-west-2

# upgrade cluster, or create cluster (if not exist), then update managednodegroup config, ..
aws cloudformation list-stacks | grep kubify-cpu-dev-west && \
    eksctl upgrade cluster --approve --asg-access -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-west.yaml" || \
        eksctl create cluster --with-oidc --install-nvidia-plugin=false -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-west.yaml"

# TODO: eksctl utils enable-secrets-encryption -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-west.yaml" on each ..
# https://eksctl.io/usage/kms-encryption/ # This Will Give Us a 4th Layer of Encrypting Secrets

# East (HA us-east-1 dev DR) cluster deployments:
export AWS_DEFAULT_REGION=us-east-1

# upgrade cluster, or create cluster (if not exist), then update managednodegroup config, ..
aws cloudformation list-stacks | grep kubify-cpu-dev-east && \
    eksctl upgrade cluster --approve --asg-access -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-east.yaml" || \
        eksctl create cluster --with-oidc --install-nvidia-plugin=false -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-east.yaml"

# GPU CLUSTERS:
##

# West (HA us-west-2 dev MAIN) cluster deployments:
export AWS_DEFAULT_REGION=us-west-2

# upgrade cluster, or create cluster (if not exist), then update managednodegroup config, ..
aws cloudformation list-stacks | grep kubify-gpu-dev-east && \
    eksctl upgrade cluster --approve --asg-access -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-gpu-dev-west.yaml" || \
        eksctl create cluster --with-oidc --install-nvidia-plugin=false -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-gpu-dev-west.yaml"

# East (HA us-east-1 dev DR) cluster deployments:
export AWS_DEFAULT_REGION=us-east-1

# upgrade cluster, or create cluster (if not exist), then update managednodegroup config, ..
aws cloudformation list-stacks | grep kubify-gpu-dev-east && \
    eksctl upgrade cluster --approve --asg-access -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-gpu-dev-east.yaml" || \
        eksctl create cluster --with-oidc --install-nvidia-plugin=false -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-gpu-dev-east.yaml"

unset AWS_DEFAULT_REGION


wait # parallel deployments, wait for them


# ........

# Update ManagedNodeGroups (if any change, or comment next sections if you don't want to update nodegroup setttings each time:)
##


# CPU CLUSTERS:
##

# West (HA us-west-2 dev MAIN) cluster deployments:
export AWS_DEFAULT_REGION=us-west-2

# update config of managed nodegroups (if exist) ..
eksctl update nodegroup -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-west.yaml" &

# East (HA us-east-1 dev DR) cluster deployments:
export AWS_DEFAULT_REGION=us-east-1

# update config of managed nodegroups (if exist) ..
eksctl update nodegroup -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-east.yaml" &

# GPU CLUSTERS:
##

# West (HA us-west-2 dev MAIN) cluster deployments:
export AWS_DEFAULT_REGION=us-west-2

# update config of managed nodegroups (if exist) ..
eksctl update nodegroup -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-gpu-dev-west.yaml" &

# East (HA us-east-1 dev DR) cluster deployments:
export AWS_DEFAULT_REGION=us-east-1

# update config of managed nodegroups (if exist) ..
eksctl update nodegroup -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-gpu-dev-east.yaml" &

unset AWS_DEFAULT_REGION

wait # parallel deployments, wait for them


#####
#####

#####
## Covers "eks" folder: Deploy/Update EKS AutoScaler to Each Cluster:
#####


# CPU CLUSTERS:
##

# West (HA us-west-2 dev MAIN) cluster deployments:
export AWS_DEFAULT_REGION=us-west-2

# Deploy/Update the autoscaler pod (safe to do anytime)
eksctl utils write-kubeconfig --set-kubeconfig-context=true --cluster=kubify-cpu-dev-west --region=${AWS_DEFAULT_REGION}
kubectl apply -f "${SCRIPT_DIR}/eks/kubify-dev/2-autoscaler-kubify-cpu-dev-west.yaml"

# East (HA us-east-1 dev DR) cluster deployments:
export AWS_DEFAULT_REGION=us-east-1

# Deploy/Update the autoscaler pod (safe to do anytime)
eksctl utils write-kubeconfig --set-kubeconfig-context=true --cluster=kubify-cpu-dev-east --region=${AWS_DEFAULT_REGION}
kubectl apply -f "${SCRIPT_DIR}/eks/kubify-dev/2-autoscaler-kubify-cpu-dev-east.yaml"


# GPU CLUSTERS:
##

# West (HA us-west-2 dev MAIN) cluster deployments:
export AWS_DEFAULT_REGION=us-west-2

# Deploy/Update the autoscaler pod (safe to do anytime)
eksctl utils write-kubeconfig --set-kubeconfig-context=true --cluster=kubify-gpu-dev-west --region=${AWS_DEFAULT_REGION}
kubectl apply -f "${SCRIPT_DIR}/eks/kubify-dev/2-autoscaler-kubify-gpu-dev-west.yaml"

# East (HA us-east-1 dev DR) cluster deployments:
export AWS_DEFAULT_REGION=us-east-1

# Deploy/Update the autoscaler pod (safe to do anytime)
eksctl utils write-kubeconfig --set-kubeconfig-context=true --cluster=kubify-gpu-dev-east --region=${AWS_DEFAULT_REGION}
kubectl apply -f "${SCRIPT_DIR}/eks/kubify-dev/2-autoscaler-kubify-gpu-dev-east.yaml"

unset AWS_DEFAULT_REGION

# ........

#####
#####

echo "NOTE: As we know us-east-1 went down for an entire day recently (do not rely on us-east-1, always have automated failover between 2 regions with a deeply automated DR pattern), we all know how important this is .."
echo "NOTE: I chose us-west-2 as the default region due to the proven fact (over the years) that us-west-2 is a lot more stable than us-east-1 (but anyway, NOW YOU HAVE MULTI-REGION REDUNDANCY AUTOMATION!!! NICE WORK!!!)"
echo "SUCCESS (but please double check).."
echo "CLUSTERS (AND AUTOSCALERS) DEPLOYED!! Happy Coding Rockstar (THANK YOU FOR CODING)!! PURE DEVEX LOVE (FOR THE WIN)!!"
echo "PRO TIP: Open your favorite (secure) kubernetes ui tool (such as Lens or for example the official VSCode \"Kubernetes\" Extension)"