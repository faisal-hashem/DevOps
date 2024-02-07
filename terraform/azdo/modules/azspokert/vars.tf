variable "rg_name" {
  type = string
  default = "defaultrg"
}
variable "environment" {
  type = string
  default = "dev"
}
variable "location" {
  type = string
  default = "eastus"
}
variable "region" {
  type = string
  default = "ue2"
}
variable "octet2" {
  type = string
  default = "224"
}
variable "nexthop_ip" {
  type = string
}
variable "spoke_subscription_id" {
  description = "ID for the target subscription to be used for route table."
  type = string
  default = "69bedceb-ae07-433f-8a58-635db0785ff6"
}