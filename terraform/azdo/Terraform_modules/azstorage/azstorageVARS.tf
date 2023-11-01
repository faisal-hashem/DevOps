variable "use_name" {
   type = string
   validation {
      condition     = length(var.use_name) < 10
      error_message = "The usename value must be 9 or less characters."
    }
}
variable "env" {
   type = string
}
variable "location" {
   type = string
}
variable "rg_name" {
   type = string
}

variable "account_tier" {
   type = string
   default = "Standard"
}

variable "account_replication_type" {
   type = string
   default = "LRS"
}

variable "account_kind" {
   type = string
   default = "StorageV2"
}


variable "subnet_id" {
  type = string
  description = "Subnet for the Private Endpoint"
  default = null
}
variable "region" {
   type = string
}

variable "name" {
   type = string
   default = ""
   description = "Name of the storage account"
}

variable "namespace_enabled" {
   type = bool
   default = false
   description = "Specify whether or not to enable the hierarchical namespace on the storage account.  Default is false"
}

variable "custom_tags" {
   default = null
   description = "Custom tags that will be merged with the locals from the module."
}

variable "acl_allowed_ips" {
   default = null
   type = list
   description = "List of IPs to be added for access on the storage account.  Providing a value here will set the default_action to Deny"
}

variable "acl_subnet_ids" {
   default = null
   type = list
   description = "Provide a list of additional Subnet / vNet IDs to be added on the Storage Account Firewall Rule.  This will concatenate existing build server subnets to any value supplied"
}

variable "versioning_enabled" {
   default = false
   type = bool
   description = "Specify whether or not to enable versioning on the storage account.  Defaults to false."
}

variable "delete_retention_policy_days" {
   default = null
   description = "Specify the number of days to enable for soft delete.  Default is false which will not enable soft delete"
}

variable "container_config" {
   default = {}
   description = "If the storage account should have containers, the calling module should supply a map containing container name, type, roles to assign and groups to assign to those roles"
}

variable "enable_private_endpoint" {
   type = bool
   default = false
   description = "This setting will toggle on or off the private endpoint."
}
/*
variable "build_subnet_ids" {
   default = null
   description = "List of Subnet IDs that contain AZDO Build Servers.  To be pulled from AZDO library group"
}

variable "netskope_ips" {
   description = "List of Netskope IPs from AZDO Library"
}
*/
variable "add_netskope_ips" {
   type = bool
   default = false
   description = "Toggle whether or not to add Netskope IPs to the target storage account firewall rules"
}

variable "acl_bypass" {
   default = null
   type = list
   #default = ["None"]
   description = "Specify whether traffic is bypassed for Logging/Metrics/AzureServices. Any combination of these three can be supplied as a list."
}