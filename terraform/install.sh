#!/bin/bash

set -x
set -e

export S3_BUCKET_TF_STATE_NAME="kubify-tf-state"
export S3_BUCKET_TF_STATE_NAME_DR="kubify-tf-state-dr" # regional redundancy
export AWS_REGION_DR="us-east-1" # east is not stable (historically), so it's for DR
export AWS_REGION="us-west-2" # west is super stable, and has the latest features, so it's for PRIMARY

if `aws s3 ls "s3://$S3_BUCKET_TF_STATE_NAME"`
then
    echo "success: s3 tf state bucket access confirmed"
else
    echo "could not find s3 bucket, so creating it, with regional redundancy, versioning and encryption"
    #
    export AWS_REGION=$AWS_REGION
    aws s3api create-bucket --bucket  $S3_BUCKET_TF_STATE_NAME --region $AWS_REGION
    aws s3api put-bucket-versioning --bucket $S3_BUCKET_TF_STATE_NAME --versioning-configuration Status=Enabled  --region $AWS_REGION
    aws s3api put-bucket-encryption --bucket $S3_BUCKET_TF_STATE_NAME --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' --region $AWS_REGION
    aws iam create-role --role-name $S3_BUCKET_TF_STATE_NAME --assume-role-policy-document file://src/kubify/templates/state/s3-trust-policy.json || true
    aws iam put-role-policy --role-name $S3_BUCKET_TF_STATE_NAME --policy-document file://src/kubify/templates/state/s3-role-perms.json --policy-name $S3_BUCKET_TF_STATE_NAME || exit 1
    export AWS_REGION=$AWS_REGION_DR
    aws s3api create-bucket --bucket  $S3_BUCKET_TF_STATE_NAME_DR --region $AWS_REGION_DR
    aws s3api put-bucket-versioning --bucket $S3_BUCKET_TF_STATE_NAME_DR --versioning-configuration Status=Enabled  --region $AWS_REGION_DR
    aws s3api put-bucket-encryption --bucket $S3_BUCKET_TF_STATE_NAME_DR --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' --region $AWS_REGION_DR
    export AWS_REGION=$AWS_REGION
    aws s3api put-bucket-replication --replication-configuration "file://src/kubify/templates/state/replicationConf.json" --bucket $S3_BUCKET_TF_STATE_NAME || exit 1
    #
#
fi

aws s3 ls s3://kubify-tf-state # check
tfsec --version >/dev/null || apt update 2>/dev/null || true
tfsec --version >/dev/null || brew install tfsec || apt install -y tfsec
tfenv --version >/dev/null || brew install tfenv || apt install -y tfenv
#
tfenv install v1.2.4 || true
tfenv use v1.2.4
cd terraform && terraform fmt --recursive && tfsec
terraform init && terraform apply