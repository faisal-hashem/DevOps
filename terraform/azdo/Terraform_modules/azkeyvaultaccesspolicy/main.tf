resource "azurerm_key_vault_access_policy" "akv_access_policy" {
  key_vault_id            = var.id
  tenant_id               = var.tenant_id
  object_id               = var.aad_principal_id
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
  certificate_permissions = var.certificate_permissions
}