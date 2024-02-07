output "id" {
  value = azurerm_storage_account.storagefileaccount.id
}

output name {
    value = azurerm_storage_account.storagefileaccount.name
}

output primary_access_key {
    value = azurerm_storage_account.storagefileaccount.primary_access_key
}

output ipaddress {
  value = azurerm_private_endpoint.storagefile_privateendpoint.private_service_connection[0].private_ip_address
}

output hostname {
  value = azurerm_storage_account.storagefileaccount.primary_file_endpoint
}