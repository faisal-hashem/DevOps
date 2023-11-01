variable "rg_name" {
  type = string
}
variable "use_name" {
  type = string
  default = "shared"
}
variable "env" {
  type = string
}
variable "app_name" {
   type = string
   default = "Insights"
}
variable "location" {
   type = string
}
variable "application_type" {
  type = string
  default = "web"
}
variable "sku" {
  type = string
  default = "PerGB2018"
}
variable "retention_in_days" {
  type = string
  default = "30"
}
variable "region" {
  type = string
}