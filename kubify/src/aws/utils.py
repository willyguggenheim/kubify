import boto3


def aws_account_id():
    # client = boto3.client("sts", aws_access_key_id=access_key, aws_secret_access_key=secret_key)
    try:
        client = boto3.client("sts")
        account_id = client.get_caller_identity()["Account"]
        return account_id
    except:
        return None
