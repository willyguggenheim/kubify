"""Main module."""

import os
import aws_constants
from aws_utils.s3_utils import get_bucket, create_bucket, put_bucket_encryption
from k8s_utils.k8s import k8s_utils

def test_or_create_s3_artifacts_bucket():
    print("checking access to artifacts s3 bucket to exist, creating it (with encryption at rest enabled) if it does not exist..")
    bucket_name = aws_constants.BUCKET_NAME
    region = aws_constants.AWS_REGION
    bucket = get_bucket(bucket_name)
    if bucket:
        print("success: s3 bucket access working")
    else:
        print("could not find s3 bucket, so creating it")
        create_bucket(bucket_name, region)
        put_bucket_encryption(bucket_name)
        print("s3 bucket encryption set")






if __name__ == '__main__':
    k8s = k8s_utils()
    k8s.set_context_get_client(os.environ.get('K8S_OVERRIDE_CONTEXT', 'default'))
    test_or_create_s3_artifacts_bucket()
    k8s.get_entrypoint()
    k8s.get_service_pod('abc')