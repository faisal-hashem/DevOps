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
variable "ase_name" {
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
variable "dotnet_version" {
   type = string
   default = "v4.0"
}

variable aad_principal_id {
   type = string
   default = "ea858716-b08a-45a5-aa15-e85953b250e2"
}

variable azure_role {
   type = string
   default = "Reader"
}

variable usermi_principal_id {
   type = string
}