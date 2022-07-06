#!/usr/local/bin/python3

import boto3

client = boto3.client("workdocs")

# Eventually this is what needs to happen:
response = client.create_user(
    # The directory ID, pulled from ssm.
    OrganizationId="{{resolve:ssm:/kubify/env/dev/infra/workspaces/directory_id}}",
    # Required. Should be automatically parsed from the email address.
    Username="usr-willy-guggenheim-1",
    EmailAddress="willy@gugcorp.com",  # Not required.
    GivenName="Willy",  # Required.
    Surname="Guggenheim",  # Required.
    # First add this SecureString, then change it after deploy
    Password="{{resolve:ssm-secure:/kubify/env/dev/infra/workspaces/usr-willy-guggenheim-1/initial_password}}",
)
