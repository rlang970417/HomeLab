#!/usr/bin/env python3

# Desc : Create a Google Cloud Service Account
#
# Usage: python3 CreateServiceAccount.py "Terraform Bot" --service_account_id "tf-bot-01"
#
# Note : This will require you have the "Service Account Admin" role.


import json
import argparse
import asyncio
from google.cloud import iam_admin_v1
from google.cloud.iam_admin_v1 import types
from google.oauth2 import service_account

# Credential Settings : Service Account Key File
credentials = service_account.Credentials.from_service_account_file('key.json')

# Configuration Settings : Target Project
with open('cfg.json') as config_file:
  data = json.load(config_file)

async def create_service_account_async(project_id, service_account_name, service_account_id):
    client = iam_admin_v1.IAMAsyncClient(credentials=credentials)

    parent = f"projects/{project_id}"

    request = iam_admin_v1.CreateServiceAccountRequest(
        name = parent,
        account_id = service_account_id,
        service_account = types.ServiceAccount(
            display_name = service_account_name
        )
    )

    response = await client.create_service_account(request=request)

    print(f"Service Account Created : {response.name}")
    print(f"Email : {response.email}")
    print(f"Unique ID : {response.unique_id}")

    return response




if __name__ == "__main__":
    project_id = data['gsettings']['projid']
    
    # Initialize the argument parser
    parser = argparse.ArgumentParser(description="Create a Google Cloud Service Account.")

    # Add arguments
    parser.add_argument(
        "service_account_name", 
        type=str, 
        help="The display name for the service account"
    )
    
    parser.add_argument(
        "--service_account_id", 
        type=str, 
        default="python-service-id", 
        help="The unique ID/slug for the account (default: %(default)s)"
    )

    # Parse the arguments from CLI
    args = parser.parse_args()

    # Run the async function with parsed arguments
    asyncio.run(
        create_service_account_async(
            project_id, 
            args.service_account_name, 
            args.service_account_id
        )
    )