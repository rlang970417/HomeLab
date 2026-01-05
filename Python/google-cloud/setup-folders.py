#!/usr/bin/env python3

import sys
import time
from google.cloud import resourcemanager_v3
from google.cloud import billing_v1

def setup_gcp_structure(domain, billing_id):
    # Initialize Clients
    folder_client = resourcemanager_v3.FoldersClient()
    project_client = resourcemanager_v3.ProjectsClient()
    billing_client = billing_v1.CloudBillingClient()

    # 1. Get Organization ID
    # Assumes you are logged in and have access to one organization
    orgs = list(resourcemanager_v3.OrganizationsClient().search_organizations())
    if not orgs:
        print("No organizations found. Ensure you are logged in.")
        return

    org_id = orgs[0].name # Format: organizations/123456789
    print(f"Using Organization: {org_id}")

    # 2. Create Folders
    folder_names = ["prod", "uat", "dev"]
    folder_map = {}

    for name in folder_names:
        operation = folder_client.create_folder(
            parent=org_id,
            folder=resourcemanager_v3.Folder(display_name=name)
        )
        print(f"Creating folder: {name}...")
        result = operation.result()
        folder_map[name] = result.name # Format: folders/12345
        print(f"Created {name} with ID: {result.name}")

    # 3. Create Projects in 'dev' folder
    dev_folder_id = folder_map["dev"]

    for i in range(1, 4):
        project_id = f"devproj-{domain.replace('.', '-')}-{i:05d}"
        display_name = f"dev-project-{i}"

        # Create Project
        project = resourcemanager_v3.Project(
            project_id=project_id,
            display_name=display_name,
            parent=dev_folder_id
        )

        print(f"Creating project {project_id}...")
        op = project_client.create_project(project=project)
        op.result() # Wait for creation

        # 4. Link Billing
        billing_request = billing_v1.UpdateProjectBillingInfoRequest(
            name=f"projects/{project_id}",
            project_billing_info=billing_v1.ProjectBillingInfo(
                billing_account_name=f"billingAccounts/{billing_id}"
            )
        )
        billing_client.update_project_billing_info(request=billing_request)
        print(f"Project {project_id} created and linked to billing.")

if __name__ == "__main__":
    # Handle Inputs (CLI args or prompts)
    my_domain = sys.argv[1] if len(sys.argv) > 1 else input("Enter domain name: ")
    my_bill_acct = sys.argv[2] if len(sys.argv) > 2 else input("Enter billing account (e.g. 012AD9-...): ")

    setup_gcp_structure(my_domain, my_bill_acct)
