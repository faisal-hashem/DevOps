import logging
from azure.identity import AzureCliCredential
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.resource import ResourceManagementClient
import os

credential = AzureCliCredential()

sub_id = os.environ["Azure_Sub_Id"] = "69bedceb-ae07-433f-8a58-635db0785ff6"

rg_client = ResourceManagementClient(credential, sub_id)

RESOURCE_GROUP_NAME = "fhtestgroup"
LOCATION = "centralus"

result = rg_client.resource_groups.create_or_update(
    RESOURCE_GROUP_NAME, {"location": LOCATION})
print(f"{result.name} and {result.location}")

VNET_NAME = ""

compute = ComputeManagementClient(credential, sub_id)
network = NetworkManagementClient(credential, sub_id)

list_vm = compute.virtual_machines.get()
