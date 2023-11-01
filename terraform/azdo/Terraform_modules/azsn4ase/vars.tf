variable "sn_cidr" {
   type = string
   default = "10.110.2.0/24"
}
variable "rg_name" {
  type = string
  default = "default"
}
variable "sn_name" {
  type = string
}
variable "vnet" {
  type = string
}
variable "private_link_endpoint_policy_enforcement" {
  type = bool
   default = null
}

variable "private_link_service_policy_enforcement" {
  type = bool 
  default = null
 }

variable "service_delegation_name" {
  type = string
  default = "Microsoft.Web/hostingEnvironments"
}

variable "service_delegation_actions" {
  type = list
  default = ["Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action","Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
}
