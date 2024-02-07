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
}

variable "acl_subnet_ids" {
   type = list
   description = "List of allowed subnet IDs for the access rule"
   default = null
}

variable "acl_allowed_ips" {
   type = list
   description = "List of allowed IPs for the access rule"
   default = null
}


variable "name" {
   default = ""
   description = "Name of the storage account to override the computed name"
   validation {
      condition     = length(var.name) < 16
      error_message = "The usename value must be 15 or less characters."
    }
}

variable "custom_tags" {
   default = null
   description = "Custom tags that will be merged with the locals from the module."
}

variable "storage_share_config" {
   description = "A map of file share, quota, and azure role assignments"
   #type = map(string)

}

variable "storage_account_permission" {
   default = null
   type = map(string)
   description = "Key, value map  of AAD Object ID to Azure Role name"
}

## Unused Vars
/*
variable "aad_principal_id" {
   type = string
   default = "be9d891d-54bc-4c52-9ff2-2a466c37c455"
}

variable "azure_role" {
   type = string
   #default = "Reader"
   default = "Storage File Data SMB Share Reader"
}

variable "sharefolder_name" {
   type = string
   default = "sharefolder"
}

#variable "subscription_id" {}

variable "share_principal_id_ro" {
   type = string
   description = "Group or User Object ID to assign read=only directly to share"
   default = null
}

variable "storage_share_settings" {
   description = "A map of file share name to quota sizes"
   type = map(string)
   default = {
      "sharefolder" = "1024"
   }
}

*/