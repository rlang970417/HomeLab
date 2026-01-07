#!/usr/bin/env python3

import json
import asyncio
from google.cloud import iam_admin_v1
from google.cloud.iam_admin_v1 import Role
from google.oauth2 import service_account

# Credential Settings : Service Account Key File
credentials = service_account.Credentials.from_service_account_file('key.json')

# Configuration Settings : Target Project
with open('cfg.json') as config_file:
  data = json.load(config_file)

async def create_custom_role(project_id, role_id, title, description, permissions):
    client = iam_admin_v1.IAMAsyncClient(credentials=credentials)

    role = Role(
        title = title,
        description=description,
        included_permissions = permissions,
        stage = "GA"

    )

    parent = f"projects/{project_id}"

    request = iam_admin_v1.CreateRoleRequest(
        parent=parent,
        role_id = role_id,
        role=role
    )

    response = await client.create_role(request=request)

    print(f"Created role : {response.name}")


if __name__ == "__main__":
    project_id = data['gsettings']['projid']
    role_id = data['gsettings']['roleid']
    title = data['gsettings']['title']
    description = data['gsettings']['description']
    permissions = data['gsettings']['permissions']

    asyncio.run(create_custom_role(project_id, role_id, title, description, permissions))

