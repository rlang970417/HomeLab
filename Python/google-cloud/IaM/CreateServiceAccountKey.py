#!/usr/bin/env python3

# Desc : Create a Google Cloud Service Account Key
#
# Usage: python3 CreateServiceAccountKey.py --service_account_id "tf-bot-01"
#
# Note : This will require you have the "Service Account Key Admin" role.


import json
import base64
import argparse
import asyncio
from google.cloud import iam_admin_v1
from google.oauth2 import service_account

# Credential Settings : Service Account Key File
credentials = service_account.Credentials.from_service_account_file('key.json')

# Configuration Settings : Target Project
with open('cfg.json') as config_file:
  data = json.load(config_file)

async def create_key_async(project_id, service_account_id):

    client = iam_admin_v1.IAMAsyncClient(credentials=credentials)

    # Construct the full resource name for the service account
    service_account_name = f"projects/{project_id}/serviceAccounts/{service_account_id}@{project_id}.iam.gserviceaccount.com"

    request = iam_admin_v1.CreateServiceAccountKeyRequest(
        name=service_account_name
    )

    # Call the API to create the key
    response = await client.create_service_account_key(request=request)

    # The private_key_data is returned as bytes (base64 encoded)
    # We decode the bytes to a string to get the actual JSON content
    private_key_data = response.private_key_data.decode('utf-8')

    # Let's write our output to STDOUT
    print(f"Private Key Data : \n {private_key_data}")
    
    # Define the filename using the service_account_id
    filename = f"{service_account_id}-key.json"
    
    # Write the JSON data to the file
    with open(filename, "w") as f:
        f.write(private_key_data)

    print(f"Service Account Key created and saved to: {filename}")

    return private_key_data

if __name__ == "__main__":
    project_id = data['gsettings']['projid']
   
    # Initialize the argument parser
    parser = argparse.ArgumentParser(description="Create a Google Cloud Service Account Key.")

    # Add arguments
    parser.add_argument(
        "--service_account_id", 
        type=str, 
        default="python-service-id", 
        help="The unique ID/slug for the account (default: %(default)s)"
    )

    # Parse the arguments from CLI
    args = parser.parse_args()
       
    service_account_id = args.service_account_id
    asyncio.run(create_key_async(project_id, service_account_id))