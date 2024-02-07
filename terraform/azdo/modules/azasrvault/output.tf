output "asr_vault_rg_name" {
  value = azurerm_resource_group.rg.name
}

output "asr_vault_rg_id" {
  value = azurerm_resource_group.rg.id
}

/*
output "asr_cache_rg_name" {
  value = azurerm_resource_group.rg_cache.name
}
*/

output "asr_vault_id" {
  value = azurerm_recovery_services_vault.asr_vault.id
}

output "asr_vault_name" {
  value = azurerm_recovery_services_vault.asr_vault.name
}

output "asr_fabric_primary_id" {
  value = azurerm_site_recovery_fabric.asr_fabric_primary.id
}

output "asr_fabric_primary_name" {
  value = azurerm_site_recovery_fabric.asr_fabric_primary.name 
}

output "asr_fabric_secondary_id" {
  value = azurerm_site_recovery_fabric.asr_fabric_secondary.id
}

output "asr_fabric_secondary_name" {
  value = azurerm_site_recovery_fabric.asr_fabric_secondary.name
}

output "asr_policy_std_id" {
  value = azurerm_site_recovery_replication_policy.asr_policy_std.id
}

output "asr_policy_dev_id" {
  value = azurerm_site_recovery_replication_policy.asr_policy_dev.id
}