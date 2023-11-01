# Using the azkeyvault module
This module will build an Azure Keyvault.  Below will outline the required variables which need to be passed to this module, as well as the optional variables which can be utilized.

## Required variables
| Variable Name | Description | 
| -------- | -------- |
| use_name |  This is the intended use of the Keyvault which should be relevant to its deployment. |
| rg_name | This is the name of the resource group in which to add the Keyvault. |
| location | This is the location in which to create the Keyvault. | 
| env | This is the environment in which to create the Keyvault.  |
| region | This is the shorthand region in which to create the vault. |

## Optional variables
| Variable Name | Default | Description |
|--|--|--|
| sku_name | standard | This is the value for the SKU of the vault.  Options are standard or premium. |
| tenant_id | eb83984f-99ea-46bb-be92-cca88ced3b85 | This is the value of our Tenant ID and defaults to our production tenant. | 
| enabled_for_disk_encryption | false | Specifies whether or not Azure Disk Encryption can retrieve secrets from the vault. |
| soft_delete_retention_days | 7 | Specifies the number of days that items should be retained for soft delete. |
| purge_protection_enabled | false | Specify whether or not to enable purge protection on the vault. |  
| aad_principal_id | someguid | AzureAD Object ID of the SPN that will be given the role in the azure_role variable. | 
| azure_role | Reader | Azure Role to assign to the GUID supplied in aad_principal_id. | 
| subnet_id | null | Subnet ID on which to put the Private Endpoint for the Keyvault.  | 
| custom_tags | null | Additional tags that can be appended to the default tags being created by the module. Format would be `custom_tags = {Application = "My Cool App",Team = "The Cool App Team'", Owner = "Suhit"}` |
| azure_rbac_enabled | false | Specify whether or not to enable Azure RBAC on the Keyvault (rather than Access Policy) |
| add_private_endpoint | false | This will toggle whether or not to attach a private endpoint.  If passing true, a subnet value will need to be provided for the variable subnet_id |

*Recently added optional variables relating to Keyvault Firewall / ACLs:*
| Variable Name | Default | Description |
|--|--|--|
| acl_bypass | None | This variable can allow for Microsoft services to bypass the ACL settings.  Options are None, AzureServices.  When **enabled_for_disk_encryption** is *true*, the module will automatically set this to *AzureServices*, as required by Azure. |
| acl_allowed_ips | null | This variable can accept a [list] of IPs that should be added to the Vault Firewall ACL. |
| acl_subnet_ids | null | This variable can accept a [list] of subnet / VNET IDs that should be added to the Vault Firewall ACL. |
| add_netskope_ips | false | This [bool] variable will toggle whether or not to automatically populate the list of Netskope CIDR ranges on the Firewall ACL. |
*Note: Values for netskope ips and build agent subnet IDs are sourced from text files within the `utility_scripts` repo in the `resources` folder.*

## Example Usage
```
The below example would be how to call the keyvault module from an app_spoke deployment

module "testakv" {
  source                      = "git@ssh.dev.azure.com:v3/GA-Infra/Terraform/Terraform_modules//azkeyvault?ref=ver2.9"
  use_name                    = "testkv"
  location                    = var.location                # This value comes from the pipeline
  env                         = var.environment             # This value comes from the pipeline
  rg_name                     = module.test_rg.rg_name      
  enabled_for_disk_encryption = "true"
  purge_protection_enabled    = "true"
  azure_role                  = "Key Vault Administrator"
  aad_principal_id            = "db5cbfd0-d84c-43e1-a13a-74a8acfaded7"
  region                      = var.region                  # This value comes from the pipeline
  azure_rbac_enabled          = true
  acl_subnet_ids              = ["/subscriptions/56b07343-7ecb-4de5-a101-5869d15f9619/resourceGroups/net_prodmgmt_uc1/providers/Microsoft.Network/virtualNetworks/mgmt_uc1_vnet/subnets/mgmt_uc1_sn04"]
  acl_allowed_ips             = ["1.2.3.4"]
  add_netskope_ips            = true
  ## If adding a Private Endpoint, uncomment and pass the below parameters with appropriate values:
  #add_private_endpoint        = true
  #subnet_id                   = data.terraform_remote_state.netspoke00.outputs.sn00_id 
}
```