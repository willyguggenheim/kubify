#!/usr/local/bin/python3

import boto3

client = boto3.client('workspaces')

response = client.register_workspace_directory(
    DirectoryId = '{{resolve:ssm:/kubify/env/dev/infra/workspaces/directory_id}}', # The directory ID, pulled from ssm, required.
    EnableWorkDocs = False, # Required.
)
