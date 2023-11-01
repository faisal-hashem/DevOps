output "sql_server_name" {
  value = azurerm_mssql_server.mssql_server.name
}

output "sql_fqdn" {
  value = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
}

output "database_id" {
  value = { for db in azurerm_mssql_database.db: db.name => db.id }
}