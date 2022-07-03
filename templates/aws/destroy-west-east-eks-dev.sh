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

# delete cluster
eksctl delete cluster -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-west.yaml"

# TODO: eksctl utils enable-secrets-encryption -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-west.yaml" on each ..
# https://eksctl.io/usage/kms-encryption/ # This Will Give Us a 4th Layer of Encrypting Secrets

# East (HA us-east-1 dev DR) cluster deployments:
export AWS_DEFAULT_REGION=us-east-1

# delete cluster
eksctl delete cluster -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-cpu-dev-east.yaml"

# GPU CLUSTERS:
##

# West (HA us-west-2 dev MAIN) cluster deployments:
export AWS_DEFAULT_REGION=us-west-2

# delete cluster
eksctl delete cluster -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-gpu-dev-west.yaml"

# East (HA us-east-1 dev DR) cluster deployments:
export AWS_DEFAULT_REGION=us-east-1

# delete cluster
eksctl delete cluster -f "${SCRIPT_DIR}/eks/kubify-dev/1-eksctl-kubify-gpu-dev-east.yaml"

echo "Your Kubify Self-Service AWS Cloud is Offline and Destroyed (for Cost or migrating to Terraform)"