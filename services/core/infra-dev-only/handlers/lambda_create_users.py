#!/usr/local/bin/python3

import boto3

client = boto3.client('workdocs')

# Eventually this is what needs to happen:
response = client.create_user(
    OrganizationId = '{{resolve:ssm:/kubify/env/dev/infra/workspaces/directory_id}}', # The directory ID, pulled from ssm.
    Username = 'usr-willy-guggenheim-1', # Required. Should be automatically parsed from the email address.
    EmailAddress = 'willy@gugcorp.com', # Not required.
    GivenName = 'Willy', # Required.
    Surname = 'Guggenheim', # Required.
    Password = '{{resolve:ssm-secure:/kubify/env/dev/infra/workspaces/usr-willy-guggenheim-1/initial_password}}', # First add this SecureString, then change it after deploy
)
