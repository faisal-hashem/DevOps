from azure.identity import AzureCliCredential
from azure.mgmt.resource import ResourceManagementClient

credential = AzureCliCredential()

subscription_id = "69bedceb-ae07-433f-8a58-635db0785ff6"

resource_client = ResourceManagementClient(credential, subscription_id)

# List Resource groups (name, location, tags)
rg_group_list = resource_client.resource_groups.list()

resource_client.resource_groups.create_or_update()

print("List of Resource Groups in your Subscription")
for i in list(rg_group_list):
    print(i.name)
    print(i.location)
    print(f"{i.tags}\n")
