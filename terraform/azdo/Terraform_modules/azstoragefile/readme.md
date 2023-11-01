# Using the azstoragefile module
This module will build a Domain Joined Azure Storage Account with a Private Endpoint and Shares.  Below will outline the required variables which need to be passed to this module, as well as the optional variables which can be utilized.

## Required variables
| Variable Name | Description | 
| -------- | -------- |
| use_name |  This is the intended use of the Storage Account which should be relevant to its deployment. Must be less than 10 characters.  This will be used to compute Storage Account name.|
| rg_name | This is the name of the resource group in which to add the Storage Account. |
| location | This is the location in which to create the Storage Account. | 
| env |  This is the environment in which to create the Storage Account.  |
| subnet_id |  Subnet ID on which to create the Private Endpoint. |
| storage_share_config | Map of file share, quota and and permission configuration.  A local variable map should be passed to this containing structure and permission set (as seen in the example below). |

## Optional variables
| Variable Name | Default | Description |
|--|--|--|
| account_tier | Standard | Account tier to use for the Storage Account.  `Standard` and `Premium` are valid options. |
| account_replication_type | LRS | Specify the account replication type for the Storage Account.  Possible values are `LRS, GRS, RAGRS, ZRS, GZRS, GARZRS`.
| account_kind | StorageV2 | Type of Storage Account.  Valid options are `BlobStorage`, `FileStorage`, `Storage`, `StorageV2`.  
| name | | If a storage account should deviate from naming standards, this value will override the computed name. Cannot exceed 15 characters. |
| custom_tags | | Additional tags that can be passed to the module.  Format would be `custom_tags = {Application = "My Cool App",Team = "The Cool App Team'", Owner = "Suhit"}` |
| storage_account_permission | null | If the storage account should have additional IAM permission, a local variable map should be passed to this containing user/group guid = azure rolename. |



*Recently added optional variables relating to Storage Account Firewall / ACLs:*
| Variable Name | Default | Description |
|--|--|--|
| acl_allowed_ips | null | This variable can accept a [list] of IPs that should be added to the Storage Account Firewall ACL. |
| acl_subnet_ids | null | This variable can accept a [list] of subnet / VNET IDs that should be added to the Storage Account Firewall ACL. |

## Example Usage
To define a list of file shares to be created with the storage account, create a local variable structured like the below. In this example, the local variable name is `share_config`, **distrib** and **vol3** are the keys/names of the file shares, each having a *quota* of 5TB, and we are assigning various guid lists to the Storage File Data DMB Contributor and Readers roles on each respective file share. This structure can be repeated within the same variable to create multiple file shares with unique permission sets.
```
locals {
  storage_roles = { # This will assign permissions to the STORAGE ACCOUNT (not the shares directly).  If an SMB Role is assigned, the shares will inherit these permissions.
    "db5cbfd0-d84c-43e1-a13a-74a8acfaded7" = "Contributor"                                      #Infrastructure
}

  share_config = { # This is the local variable for the share, quota, and role setup.
    "distrib" : {
      quota = "5120"
      roles = {
        "Storage File Data SMB Share Contributor"  = ["db5cbfd0-d84c-43e1-a13a-74a8acfaded7"]   #Infrastructure
        "Storage File Data SMB Share Reader" = ["100b5186-2c3f-4669-86df-6bf486783677"]         #ITDept
      }
    }
    "vol3" : {
      quota = "5120"
      roles = {
        "Storage File Data SMB Share Contributor" = ["db5cbfd0-d84c-43e1-a13a-74a8acfaded7"]    #Infrastructure
        "Storage File Data SMB Share Reader" = ["100b5186-2c3f-4669-86df-6bf486783677"]         #ITDept
      }
    }

  }
}
```

Module Usage Example:
```
module "storagefile" {
    source            = "git@ssh.dev.azure.com:v3/GA-Infra/Terraform/Terraform_modules//azstoragefile?ref=srf-azstoragefileupdates"
    use_name          = "itfiler"
    env               = var.environment
    location          = var.location
    rg_name           = module.itfiler_rg.rg_name
    storage_account_permission = local.storage_roles
    storage_share_config = local.share_config
    subnet_id         = data.terraform_remote_state.netspoke00.outputs.sn00_id  # This is the subnet for the Private Endpoint
    #acl_allowed_ips = ["8.8.8.8"]
    #acl_subnet_ids = ["/subscriptions/put/desired/id/here/sn_00"]              # If any specific subnets need access 
}
 ```