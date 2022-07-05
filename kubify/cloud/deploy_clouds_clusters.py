from kubify.kubify import test_or_create_s3_artifacts_bucket
from python_terraform import *

test_or_create_s3_artifacts_bucket(bucket_name="kubify-tf-state", region="us-west-2")

# terraform.__init__()
tf = Terraform(working_dir="terraform")
if tf.plan(refresh=True, var={"cluster_name": os.environ.get("KUBIFY_ENV", "dev")}):
    while input("Deploy Clouds? [y/n]") == "y":
        tf.apply(
            refresh=False, var={"cluster_name": os.environ.get("KUBIFY_ENV", "dev")}
        )