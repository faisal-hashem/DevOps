variable "use_name"{
    type = string
}

variable "env"{
    type = string
}

variable "rg_name"{
    type = string
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