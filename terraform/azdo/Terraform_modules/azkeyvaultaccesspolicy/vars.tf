variable "id" {
  description = "ID of the Azure keyvault"   
}

variable tenant_id {
  description = "Tenant's GUID identifier."
  type        = string
  default     = "eb83984f-99ea-46bb-be92-cca88ced3b85"
}

variable aad_principal_id {
  description = "Details of SPN in AAD to be used for the account." 
  type        = string
  default     = "ea858716-b08a-45a5-aa15-e85953b250e2"
}

variable key_permissions {
  default     = null  
  description = "key permissions for key vault access policy set up." 
  type        = list(string)
}

variable secret_permissions {
  default     = null
  description = "Secret permissions for key vault access policy set up."
  type        = list(string)
}

variable certificate_permissions {
   default     = null
   description = "Certificate permissions for key vault access policy set up."
   type        = list(string)
}

variable object_id {
  description = "" 
  type        = string
  default     = "ea858716-b08a-45a5-aa15-e85953b250e2"
}
