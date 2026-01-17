#!/usr/bin/env python3

# Desc : Create a Google Kubernetes Engine (GKE) Standard Cluster

import json
import asyncio
from google.cloud import container_v1
from google.oauth2 import service_account

# Credential Settings : Service Account Key File
credentials = service_account.Credentials.from_service_account_file('key.json')

# Configuration Settings : Target Project
with open('cluster-cfg.json') as config_file:
  data = json.load(config_file)

async def create_gke_cluster(project_id, zone, cluster_name):
    """
    Creates a GKE standard cluster with 2 worker nodes.

    Args:
        project_id (str): Google Cloud project ID.
        zone (str): Zone where the cluster will be created.
        cluster_name (str): Name of the GKE cluster.
    """
    # Initialize the Cluster Manager client
    client = container_v1.ClusterManagerClient(credentials=credentials)

    # Define the cluster configuration
    cluster = {
        "name": cluster_name,
        "initial_node_count": 2,
        "node_config": {
            "machine_type": "e2-medium",  # Default machine type for worker nodes
            "disk_size_gb": 100,  # Default disk size for worker nodes
            "oauth_scopes": [
                "https://www.googleapis.com/auth/cloud-platform"
            ],
        },
        "network": "default",  # Use the default VPC network
        "subnetwork": "default",  # Use the default subnetwork
    }

    # Create the cluster request
    request = container_v1.CreateClusterRequest(
        project_id=project_id,
        zone=zone,
        cluster=cluster,
    )

    # Call the API to create the cluster
    operation = client.create_cluster(request=request)

    print(f"Cluster creation initiated: {operation.name}")
    print("Please wait while the cluster is being created...")

if __name__ == "__main__":
    # Replace these values with your own
    project_id = data['gsettings']['projid']
    zone = data['gsettings']['zone']
    cluster_name = data['gsettings']['clustername']

    asyncio.run(create_gke_cluster(project_id, zone, cluster_name))