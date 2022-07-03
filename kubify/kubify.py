"""Main module."""

import os
import kubify.aws_constants as aws_constants
import boto3

# from aws_utils.s3_utils import s3_utils
import kubify.aws_utils as s3_utils

# from k8s_utils.k8s import k8s_utils
import kubify.k8s_utils as k8s_utils


def test_or_create_s3_artifacts_bucket(
    bucket_name=aws_constants.BUCKET_NAME,
    region=aws_constants.AWS_REGION,
    dr_replication=True,
):
    print(
        "checking access to artifacts s3 bucket to exist, creating it (with encryption at rest enabled) if it does not exist.."
    )
    s3 = s3_utils()
    bucket = s3.get_bucket(bucket_name)
    if bucket:
        print("success: s3 bucket access working")
    else:
        print("could not find s3 bucket, so creating it")
        s3.create_bucket(bucket_name, region)
        s3.put_bucket_encryption(bucket_name)
        versioning = s3.BucketVersioning(bucket_name)
        versioning.enable()
        s3.put_public_access_block(
            Bucket=bucket_name,
            PublicAccessBlockConfiguration={
                "BlockPublicAcls": True,
                "IgnorePublicAcls": True,
                "BlockPublicPolicy": True,
                "RestrictPublicBuckets": True,
            },
        )
        s3.put_bucket_versioning(
            Bucket=bucket_name,
            VersioningConfiguration={"Status": "Enabled"},
        )
        if dr_replication:
            primary_bucket_name = bucket_name
            dr_bucket_name = f"{bucket_name}-dr"
            dr_region = "us-east-1"  # region with latest features, so it's good for DR workloads
            test_or_create_s3_artifacts_bucket(
                bucket_name=dr_bucket_name, region=dr_region, dr_replication=False
            )
            client = boto3.client("sts")
            account_id = client.get_caller_identity()["Account"]
            s3.put_bucket_replication(
                Bucket=primary_bucket_name,
                # Modify the entry below with your account and the replication role you created
                ReplicationConfiguration={
                    "Role": f"arn:aws:iam::{account_id}:role/ReplicationRole",
                    "Rules": [
                        {
                            "Priority": 1,
                            "Destination": {"Bucket": f"arn:aws:s3:::{dr_bucket_name}"},
                            "Status": "Enabled",
                        },
                    ],
                },
            )
        print("s3 bucket replication, versioning and security set")


if __name__ == "__main__":
    k8s = k8s_utils()
    os.environ["K8S_OVERRIDE_CONTEXT"] = "kind-kind"
    # k8s.set_context_get_client(os.environ.get('K8S_OVERRIDE_CONTEXT', 'default'))
    test_or_create_s3_artifacts_bucket()
    k8s.get_entrypoint()
    k8s.get_service_pod("abc")
