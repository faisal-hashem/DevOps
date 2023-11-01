output asr_container_primary_id {
  value = azurerm_site_recovery_protection_container.asr_container_primary.id
}

output asr_container_primary_name {
  value = azurerm_site_recovery_protection_container.asr_container_primary.name 
}

output asr_container_secondary_id {
  value = azurerm_site_recovery_protection_container.asr_container_secondary.id
}

output asr_container_secondary_name {
  value = azurerm_site_recovery_protection_container.asr_container_secondary.name
}

output asr_cache_storage_primary_id {
  value = azurerm_storage_account.asr_cache_storage_primary.id
}

output asr_cache_storage_secondary_id {
  value = azurerm_storage_account.asr_cache_storage_secondary.id
}