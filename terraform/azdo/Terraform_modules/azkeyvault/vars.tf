variable "use_name" {
   type = string
}

variable "rg_name" {
  description = "Name of resource group to deploy resources in."
  type        = string
}

variable "sku_name" {
  description = "Name of the SKU used for this Key Vault. Possible values are `standard` and `premium`."
  default     = "standard"
  type        = string
}

variable "tenant_id" {
  description = "Tenant's GUID identifier."
  type        = string
  default     = "eb83984f-99ea-46bb-be92-cca88ced3b85"
}

variable "enabled_for_disk_encryption" {
  description = "Flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to `false`."
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted."
  type        = number
  default     = 7

}

variable "purge_protection_enabled" {
  description = "Flag to specify whether Purge-Protection is enabled. Deleting Key Vault with Purge Protection Enabled will schedule the Key Vault to be deleted, currently 90 days."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}


variable "location" {
  description = "Location of key vault account."
  type = string
}

variable aad_principal_id {
  description = "Details of SPN in AAD to be used for the account." 
  type = string
  default = "ea858716-b08a-45a5-aa15-e85953b250e2"
}

variable azure_role {
  description = "Details of SPN in AAD to be used for the account."   
  type = string
  default = "Reader"
}

variable subnet_id {
  description = "ID of subnet to be used for this Key Vault's Private Endpoint.  Not required if not adding a Private Endpoint." 
  type = string
  default = null
}

variable "custom_tags" {
  default = null
  description = "Provide any additional desired tags to be applied to all resources"
}

variable "env" {
   type = string
}
variable "region" {
  type = string
}

variable "azure_rbac_enabled" {
  type = bool
  default = false
  description = "Specify whether or not to allow Azure RBAC to access the KV.  Defaults to false"
}

#variable "allowed_subnet_ids" {
#  type = list
#  default = null
#  description = "List of allowed subnet IDs to access the keyvault"
#}

variable "acl_bypass" {
  default = "None"
  description = "Option to allow services to bypass the firewall.  Possible options are None or AzureServices"
} 

variable "acl_allowed_ips" {
  type = list
  description = "Provide a list of additional IPs that should be added to the Firewall of the target Keyvault."
  default = null
}

variable "acl_subnet_ids" {
  type = list
  description = "Provide a list of Subnet/VNET IDs that should be added to the Firewall of the target Keyvault.  This is for the Firewall of the Keyvault, NOT the Private Endpoint"
  default = null
}

variable "add_netskope_ips" {
  type = bool
  default = false
  description = "Toggle whether or not to automatically add the known Netskope CIDR ranges to the Firewall on the target Keyvault.  Passing this as true will append the Netskope IPs to the target Keyvault firewall."
} 

variable "add_private_endpoint" {
  type = bool
  default = false
  description = "Toggle whether or not to attach a Private Endpoint to the target Keyvault."
} 
/*
variable "netskope_ips" {
  description = "This variable contains the list of IP addresses that we have listed for Netskope.  The value is sourced from the AZDO pipeline | environment - global variable group and must be passed when calling this module."
}
variable "build_subnet_ids" {
  default = null
  description = "This variable contains a ',' separated list of Build Subnet IDs, currently passing in from the AZDO Pipline | environment - global variable group.  This must be passed when calling this module."
}
*/