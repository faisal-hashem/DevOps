variable "use_name" {
   type = string
}
variable "rg_name" {
  type = string
}
variable "location" {
  type = string
}
variable "mssqlpassword" {
  type = string
}
variable "env" {
  type = string
}
variable "aad_sqladmin_id" {
  type = string
}

variable "aad_principal_id" {
  type = string
}

variable "max_size_gb" {
  default = "2"
}

variable "sql_sku_name" {
  default = "Basic"
}

variable "aad_sqladmin_login" {
  default = "IT_DS_Admin"
}

variable "sqlserver_name" {
  default = null
  description = "Name of the SQL Server to be created"
}

variable "sqldb_name" {
  default = null
  description = "Name of the SQL DB to be created"
}

variable dbstore_name {
  default = null
  description = "Name for the storage account used for the auditing"
}

variable "custom_tags" {
  default = null
  description = "Provide any additional desired tags to be applied to all resources"
}