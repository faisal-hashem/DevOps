import os
import random
import string

from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.resource import ResourceManagementClient

credentials = DefaultAzureCredential()
subscription = "69bedceb-ae07-433f-8a58-635db0785ff6"

resource_client = ResourceManagementClient(credentials, subscription)
list_of_rg = resource_client.resource_groups.list()

devapp_rgs = []

for i in list_of_rg:
    devapp_rgs.append(i.name)

print(devapp_rgs)

compute = ComputeManagementClient(credentials, subscription)
compute.virtual_machines.get()
