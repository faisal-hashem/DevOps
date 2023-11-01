resource "azurerm_resource_group" "rg" {
    # This will hold the vault, fabrics, policies, containers, mappings
    name = "rg-asrvault-${var.region}-to-${var.region_secondary}-${var.subscription}"
    location = var.location_secondary
}

resource "azurerm_recovery_services_vault" "asr_vault" {
  name                = "asrvault-${var.region}-to-${var.region_secondary}-${var.subscription}"
  location            = var.location_secondary
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

resource "azurerm_site_recovery_fabric" "asr_fabric_primary" {
  name                = "asr-fabric-primary-${var.region}-to-${var.region_secondary}-${var.subscription}"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.asr_vault.name
  location            = var.location
}

resource "azurerm_site_recovery_fabric" "asr_fabric_secondary" {
  name                = "asr-fabric-secondary-${var.region}-to-${var.region_secondary}-${var.subscription}"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.asr_vault.name
  location            = var.location_secondary
}

resource "azurerm_site_recovery_replication_policy" "asr_policy_std" {
  name                                                 = "asr-policy-std-${var.region}-to-${var.region_secondary}-${var.subscription}"
  resource_group_name                                  = azurerm_resource_group.rg.name
  recovery_vault_name                                  = azurerm_recovery_services_vault.asr_vault.name
  recovery_point_retention_in_minutes                  = 24 * 60
  application_consistent_snapshot_frequency_in_minutes = 4 * 60
}

resource "azurerm_site_recovery_replication_policy" "asr_policy_dev" {
  name                                                 = "asr-policy-dev-${var.region}-to-${var.region_secondary}-${var.subscription}"
  resource_group_name                                  = azurerm_resource_group.rg.name
  recovery_vault_name                                  = azurerm_recovery_services_vault.asr_vault.name
  recovery_point_retention_in_minutes                  = 24 * 60
  application_consistent_snapshot_frequency_in_minutes = 12 * 60
}

resource "azurerm_site_recovery_network_mapping" "network_mapping" {
  name                        = "network-mapping-${var.region}-to-${var.region_secondary}-${var.subscription}"
  resource_group_name         = azurerm_resource_group.rg.name
  recovery_vault_name         = azurerm_recovery_services_vault.asr_vault.name
  source_recovery_fabric_name = azurerm_site_recovery_fabric.asr_fabric_primary.name
  target_recovery_fabric_name = azurerm_site_recovery_fabric.asr_fabric_secondary.name
  source_network_id           = var.vnetid_primary
  target_network_id           = var.vnetid_secondary
}