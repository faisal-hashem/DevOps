variable "use_name" {
   type = string
}
variable "env" {
   type = string
}
variable "app_name" {
   type = string
}
variable "location" {
   type = string
}
variable "rg_name" {
   type = string
}
variable "asp_id" {
   type = string
}
variable aad_principal_id {
   type = string
   default = "ea858716-b08a-45a5-aa15-e85953b250e2"
}
variable azure_role {
   type = string
   default = "Reader"
}
variable sa_name {
   description = "Name of the Storage Account for the azure function"
   type = string
}
variable sa_primary_access_key {
   description = "Primary access key of the storage account for the azure function"
   type = string
}
variable "app_settings" {
   type = map
   default = {
      WEBSITE_TIME_ZONE = "US Eastern Standard Time"
      WEBSTIE_HTTPLOGGING_RETENTION_DAYS = "7"
      WEBSITE_NODE_DEFAULT_VERSION = "6.9.1"
   }
}
variable "identity_ids" {
   description = "List of AAD ids for the function app to leverage"
   default = null
}
