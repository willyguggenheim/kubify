import boto3
import botocore


class S3Utils:
    def __init__(self):
        self.client = boto3.resource("s3")

    def get_bucket(self, bucket_name):
        try:

            self.client.meta.client.head_bucket(Bucket=bucket_name)
            print("Bucket Exists!")
            bucket = self.client.Bucket(bucket_name)
            return bucket
        except botocore.exceptions.ClientError as e:
            # If a client error is thrown, then check that it was a 404 error.
            # If it was a 404 error, then the bucket does not exist.
            error_code = int(e.response["Error"]["Code"])
            if error_code == 403:
                print("Private Bucket. Forbidden Access!")
                return None
            elif error_code == 404:
                print("Bucket Does Not Exist!")
                return None

    def create_bucket(self, bucket_name, region):
        response = self.client.create_bucket(
            Bucket=bucket_name, CreateBucketConfiguration={"LocationConstraint": region}
        )
        return response

    def put_bucket_encryption(self, bucket_name):
        response = self.client.put_bucket_encryption(
            Bucket=bucket_name,
            ServerSideEncryptionConfiguration={
                "Rules": [
                    {"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}},
                ]
            },
        )
        return response
