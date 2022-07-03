import boto3, botocore
from ..aws_constants import *

s3 = boto3.resource('s3')

def get_bucket(bucket_name):
    try:
        
        s3.meta.client.head_bucket(Bucket=bucket_name)
        print("Bucket Exists!")
        bucket = s3.Bucket('name')
        return bucket
    except botocore.exceptions.ClientError as e:
        # If a client error is thrown, then check that it was a 404 error.
        # If it was a 404 error, then the bucket does not exist.
        error_code = int(e.response['Error']['Code'])
        if error_code == 403:
            print("Private Bucket. Forbidden Access!")
            return None
        elif error_code == 404:
            print("Bucket Does Not Exist!")
            return None
    
def create_bucket(bucket_name, region):
    response = s3.create_bucket(
        Bucket=bucket_name,
        CreateBucketConfiguration={
        'LocationConstraint': region
    }
    )
    return response        
    
def put_bucket_encryption(bucket_name):
    response = s3.put_bucket_encryption(
        Bucket=bucket_name,
        ServerSideEncryptionConfiguration={
            'Rules': [
                {
                    'ApplyServerSideEncryptionByDefault': {
                        'SSEAlgorithm': 'AES256'
                    }
                },
            ]
        }
    )
    return response