resource "azurerm_storage_account" "asr_cache_storage_primary" {
  name                     = "asrcache${var.usename}${var.region}to${var.region_secondary}"
  resource_group_name      = var.asr_cache_rg
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "asr_cache_storage_secondary" {
  name                     = "asrcache${var.usename}${var.region_secondary}to${var.region}"
  resource_group_name      = var.asr_cache_rg_secondary
  location                 = var.location_secondary
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_site_recovery_protection_container" "asr_container_primary" {
  name                 = "asr-container-primary-${var.usename}-${var.region}-to-${var.region_secondary}"
  resource_group_name  = var.asr_vault_rg
  recovery_vault_name  = var.asr_vault_name
  recovery_fabric_name = var.asr_fabric_primary_name
}

resource "azurerm_site_recovery_protection_container" "asr_container_secondary" {
  name                 = "asr-container-secondary-${var.usename}-${var.region}-to-${var.region_secondary}"
  resource_group_name  = var.asr_vault_rg
  recovery_vault_name  = var.asr_vault_name
  recovery_fabric_name = var.asr_fabric_secondary_name
}

resource "azurerm_site_recovery_protection_container_mapping" "container-mapping" {
  name                                      = "container-mapping-${var.usename}-${var.region}-to-${var.region_secondary}"
  resource_group_name                       = var.asr_vault_rg
  recovery_vault_name                       = var.asr_vault_name
  recovery_fabric_name                      = var.asr_fabric_primary_name
  recovery_source_protection_container_name = azurerm_site_recovery_protection_container.asr_container_primary.name
  recovery_target_protection_container_id   = azurerm_site_recovery_protection_container.asr_container_secondary.id
  recovery_replication_policy_id            = var.asr_vault_policy_id
}

resource "azurerm_site_recovery_protection_container_mapping" "container-mapping-failback" {
  name                                      = "container-mapping-${var.usename}-${var.region_secondary}-to-${var.region}"
  resource_group_name                       = var.asr_vault_rg
  recovery_vault_name                       = var.asr_vault_name
  recovery_fabric_name                      = var.asr_fabric_secondary_name
  recovery_source_protection_container_name = azurerm_site_recovery_protection_container.asr_container_secondary.name
  recovery_target_protection_container_id   = azurerm_site_recovery_protection_container.asr_container_primary.id
  recovery_replication_policy_id            = var.asr_vault_policy_id
}