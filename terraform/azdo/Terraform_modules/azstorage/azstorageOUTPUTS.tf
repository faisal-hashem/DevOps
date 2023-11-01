output "id" {
  value = azurerm_storage_account.storage_account.id
}

output name {
    value = azurerm_storage_account.storage_account.name
}

output primary_access_key {
    value = azurerm_storage_account.storage_account.primary_access_key
}

output ipaddress { # wrapping this in the one function so that if a private endpoint is not required, this output doesn't fail due to absence of a Private Service Connection
  value = one(azurerm_private_endpoint.private_endpoint_blob[*].private_service_connection[0].private_ip_address)
}

output hostname {
  value = azurerm_storage_account.storage_account.primary_file_endpoint
}