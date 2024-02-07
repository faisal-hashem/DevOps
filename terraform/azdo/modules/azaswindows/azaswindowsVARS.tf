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
   default = null
}

variable "current_stack" {
    description = "Application stack for Windows Web App"
    default = "dotnet"
    validation {
        condition = contains(["dotnet","dotnetcore","node","python","php","java"], var.current_stack)
        error_message = "Invalid option.  Choices include: \"dotnet\",\"dotnetcore\",\"node\",\"python\",\"php\",\"java\""
    }
}

## Use one of these below, not both.  Depending on how we're going to name slots
variable "slot_names" {
    description = "Names of the additional slots to be provisioned"
    default = null
}

variable "slot_count" {
    description = "Number of additional slots to be provisioned on the web app"
    default = 0
}
variable "region" {
  type = string
}
variable identity_type {
   type = string
   default = "UserAssigned"
   description = "Possible values are 'SystemAssigned', 'UserAssigned','SystemAssigned, UserAssigned' (to enable both)."
}
variable identity_ids {
   type = string
   default = null
   description = "This is required when type is set to UserAssigned or SystemAssigned, UserAssigned."
}
