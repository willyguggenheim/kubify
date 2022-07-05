from sortedcontainers import SortedKeyList
from kubify.kubify import test_or_create_s3_artifacts_bucket
from boto3 import Session
from pytest_terraform import terraform
from python_terraform import *
import google.auth
credentials, project = google.auth.default() # gcloud auth application-default login
from azure.identity import DefaultAzureCredential
# Acquire a credential object
credential = DefaultAzureCredential()

# terraform.__init__()
tf = Terraform(working_dir="terraform")
if tf.plan(refresh=True, var={"cluster_name": os.environ.get("KUBIFY_ENV", "dev")}):
    while input("Deploy Clouds? [y/n]") == "y":
        tf.apply(
            refresh=False, var={"cluster_name": os.environ.get("KUBIFY_ENV", "dev")}
        )

# @terraform('aws_eks', scope='session')
# def test_eks(aws_eks):
#    assert aws_eks["modules.aws.eks.outputs.arn"].contains(":cluster/kubify") == True
