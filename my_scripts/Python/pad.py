from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
import os

client = ComputeManagementClient()
