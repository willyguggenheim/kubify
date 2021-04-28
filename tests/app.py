import boto3
import os

s3 = boto3.resource('s3', 
    aws_access_key_id = 'accessKey1',
    aws_secret_access_key = 'verySecretKey1',
    endpoint_url = 'http://0.0.0.0:8000/')

def add_initial_files():
    s3.create_bucket(Bucket='mybucket')
    s3.Object('mybucket', 'DevOps in Python.pdf').put(Body=open('DevOps in Python.pdf', 'rb'))
    s3.Object('mybucket', 'DevOps in Python.tif').put(Body=open('DevOps in Python.tif', 'rb'))
    print("OK")

if __name__ == '__main__':
    add_initial_files()