# Using the azstorage module
This module will build an Azure Storage Account.  Below will outline the required variables which need to be passed to this module, as well as the optional variables which can be utilized.

## Required variables
| Variable Name | Description | 
| -------- | -------- |
| use_name |  This is the intended use of the Storage Account which should be relevant to its deployment. Must be less than 10 characters.  This will be used to compute Storage Account name.|
| rg_name | This is the name of the resource group in which to add the Storage Account. |
| location | This is the location in which to create the Storage Account. | 
| env | This is the environment in which to create the Storage Account.  |
| region | This is the shorthand region in which to create the Storage Account. |

## Optional variables
| Variable Name | Default | Description |
|--|--|--|
| account_tier | Standard | Account tier to use for the Storage Account.  `Standard` and `Premium` are valid options. |
| account_replication_type | LRS | Specify the account replication type for the Storage Account.  Possible values are `LRS, GRS, RAGRS, ZRS, GZRS, GARZRS`.
| account_kind | StorageV2 | Type of Storage Account.  Valid options are `BlobStorage`, `FileStorage`, `Storage`, `StorageV2`.  
| subnet_id | null | Subnet ID on which to create the Private Endpoint if desired. |
| name | | If a storage account should deviate from naming standards, this value will override the computed name. |
| namespace_enabled | false | Toggles on Hierarchical Namespace for the target Storage Account. |
| custom_tags | | Additional tags that can be passed to the module.  Format would be `custom_tags = {Application = "My Cool App",Team = "The Cool App Team'", Owner = "Suhit"}` |
| versioning_enabled | false | Specify whether or not to enable versioning on the Storage Account. |
| delete_retention_policy_days | null | Enable soft delete for the Storage Account by specifying number of days to retain. This should be a value between 1 and 365. |
| container_config | null | If the storage account should have containers, a local variable map should be passed to this containing structure and permission set. |
| enable_private_endpoint | false | Specify whether or not to attach a Private Endpoint to the Storage Account. |


*Recently added optional variables relating to Storage Account Firewall / ACLs:*
| Variable Name | Default | Description |
|--|--|--|
| acl_allowed_ips | null | This variable can accept a [list] of IPs that should be added to the Storage Account Firewall ACL. |
| acl_subnet_ids | null | This variable can accept a [list] of subnet / VNET IDs that should be added to the Storage Account Firewall ACL. |
| acl_bypass | None | This variable specifies whether or not the ACL is bypassed for various services.  Possible values include `Logging`, `Metrics`, `AzureServices`, `None`.
| add_netskope_ips | false | This [bool] variable will toggle whether or not to automatically populate the list of Netskope CIDR ranges on the Firewall ACL. |
*Note: Values for netskope ips and build agent subnet IDs are sourced from text files within the `utility_scripts` repo in the `resources` folder.*

## Example Usage
To define a list of containers to be created with the storage account, create a local variable structured like the below.  In this example, the local variable name is "container_config", "container1" is the key/name of the first container, it is of type "blob", and we are assigning a guid to the Storage Blob Data Contributor role.  This structure can be repeated within the same variable to create multiple containers.
```
locals {
  container_config = {
    "container1" : {
      type = "blob"
      roles = {
        "Storage Blob Data Contributor"  = ["62c18094-d0e3-4772-a409-1fee1bda52d4"]
      }
    }
  }
}
```

Module Usage Example:
```
module "storageaccount" {
  source    = "git@ssh.dev.azure.com:v3/MYCOMP/Terraform/Terraform_modules//azstorage?ref=ver2.9"
  use_name  = "srf64test"
  env       = var.environment
  location  = var.location
  rg_name   = module.vmtest_rg.rg_name
  region    = var.region 
  #acl_allowed_ips      = ["68.118.228.34"]
  #acl_subnet_ids = []  # any additional subnets that should be enabled in firewall
  #versioning_enabled  = true
  #delete_retention_policy_days = 45
  #container_config    = local.container_config 
  add_netskope_ips = true
  #acl_bypass = ["Metrics", "Logging", "AzureServices"]  # Can be any combination of these three
  ## If private endpoint required, uncomment and supply below parameters
  #enable_private_endpoint = true
  #subnet_id = data.terraform_remote_state.netspoke00.outputs.sn00_id
 }
 ```