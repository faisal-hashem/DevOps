variable "spoke_subscription_id" {
  description = "ID for the target subscription to be used for Spoke VNet."
  type = string
  default = "69bedceb-ae07-433f-8a58-635db0785ff6"
}

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
