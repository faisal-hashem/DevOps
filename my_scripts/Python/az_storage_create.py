import os
from azure.identity import AzureCliCredential
from azure.mgmt.resource import ResourceManagementClient, DeploymentMode

sub_id = "69bedceb-ae07-433f-8a58-635db0785ff6"
location = "centralus"
rg_name = "fh-test-rg"
deployment_name = "storageDeployment"
storage_account_name = 'fhstoragetest01259'

arm_template_path = "storage_account_template.json"

creds = AzureCliCredential()
resource_client = ResourceManagementClient(creds, sub_id)

storage_rg = resource_client.resource_groups.create_or_update(
    rg_name, {"location": location})
print("RG has been created")

with open(arm_template_path, 'r') as template_file:
    template = template_file.read()

parameters = {
    'storageAccountName': {'value': storage_account_name}
}
