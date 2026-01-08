#!/usr/bin/env python3

import json
import asyncio
from google.cloud import iam_admin_v1
from google.oauth2 import service_account

# Credential Settings : Service Account Key File
credentials = service_account.Credentials.from_service_account_file('key.json')

# Configuration Settings : Target Project
with open('cfg.json') as config_file:
  data = json.load(config_file)
  
async def get_role_async(project_id, role_id):

    client = iam_admin_v1.IAMAsyncClient(credentials=credentials)

    role_name = f"projects/{project_id}/roles/{role_id}"

    request = iam_admin_v1.GetRoleRequest(name=role_name)

    response = await client.get_role(request=request)

    print(f"Role Name : {response.name}")
    print(f"Role Stage : {response.stage}")
    print(f"Title : {response.title}")
    print(f"Description : {response.description}")
    print(f"Permissions : {response.included_permissions}")



if __name__ == "__main__":
    project_id = data['gsettings']['projid']
    role_id = data['gsettings']['roleid']
    asyncio.run(get_role_async(project_id,role_id))