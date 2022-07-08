##
## for when using localstack in "local" mode (non-did)
import os
import sys

if os.environ["STAGE"] == "local":
    sys.path += [f"{os.getcwd()}/python/lib/python3.7/site-packages"]
##

import boto3
import json
import kafka
import os
import logging

log_level = os.environ.get("LOG_LEVEL", "INFO")
logging.root.setLevel(logging.getLevelName(log_level))  # type: ignore
_logger = logging.getLogger(__name__)


def lambda_handler(event, context):
    _logger.info(f"Incoming event: {event}")
    try:
        print("Hello Kubify Lambda")
    except Exception as e:
        _logger.error(f"Unexpected error: {e}")
        raise e
    return {"statusCode": 200, "test_key": "test_return_val"}
