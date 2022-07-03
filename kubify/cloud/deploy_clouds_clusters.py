from kubify.kubify import test_or_create_s3_artifacts_bucket
import checkov
import bandit
import flake8
import black
from boto3 import Session
from pytest_terraform import terraform
from python_terraform import *

# state bucket with regionaly redundancy
S3_BUCKET_TF_STATE_NAME = "kubify-tf-state"
AWS_REGION = "us-west-2"
test_or_create_s3_artifacts_bucket(
    bucket_name="kubify-tf-state", region="us-west-2")

# security checks
checkov()
bandit()

# linting
flake8()
black()

# terraform.__init__()
tf = Terraform(working_dir='terraform')
if tf.plan(refresh=True, var={'cluster_name': os.environ.get("KUBIFY_ENV", 'dev')}):
    while input("Deploy Clouds? [y/n]") == "y":
        tf.apply(refresh=False, var={
                 'cluster_name': os.environ.get("KUBIFY_ENV", 'dev')})

# @terraform('aws_eks', scope='session')
# def test_eks(aws_eks):
#    assert aws_eks["modules.aws.eks.outputs.arn"].contains(":cluster/kubify") == True
