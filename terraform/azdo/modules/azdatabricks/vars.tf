variable "vnet_id" {
    type = string
    default = null
}

variable "public_subnet_name" {
    type = string
    default = null
}

variable "private_subnet_name" {
    type = string
    default = null
}

variable "location" {
    type = string
    default = null
}

variable "rg_name" {
    type = string
    default = null
}

variable "dbks_instance_name" {
    type = string
    default = null  
}

variable "sku" {
    type = string
    default = "premium"
}

variable "network_security_group_rules_required" {
    type = string
    default = "AllRules"
}

variable "public_network_access_enabled" {
    type = bool
    default = true
}