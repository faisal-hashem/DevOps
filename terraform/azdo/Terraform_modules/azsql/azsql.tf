locals {
  required_tags = {
    environment     = var.env
    TFModifiedTime  = formatdate("YYYYMMDD_hhmmss ZZZ", timestamp())
    CreationMethod  = "Terraform"
  }
}

#create a storage account to be used by DB resources
resource "azurerm_storage_account" "dbstore" {
  name                     =  var.dbstore_name != null ? var.dbstore_name : "ga0${var.use_name}0${var.env}"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(local.required_tags, var.custom_tags)
}

#create a mssql server
resource "azurerm_mssql_server" "dbmssqlsvr" {
  name                         = var.sqlserver_name != null ? var.sqlserver_name : "${var.use_name}${var.env}sqlsvr"
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.mssqlpassword
  minimum_tls_version          = "1.2"
  #public_network_access_enabled = false
  #disabling public network access requires that a private endpoint be established for the DB
  #that code will need to be developed and likely a subnet provided within the subscription

  tags = merge(local.required_tags, var.custom_tags)
}
/*
resource "azurerm_role_assignment" "sql_server_contributor" {
  scope                = azurerm_mssql_server.dbmssqlsvr.id
  role_definition_name = "sql server contributor" #6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437 is the ID per MSFT
  principal_id         = var.aad_principal_id
}

resource "azurerm_role_assignment" "sql_db_contributor" {
  scope                = azurerm_mssql_server.dbmssqlsvr.id
  role_definition_name = "sql db contributor"  #9b7fa17d-e63e-47b0-bb0a-15c516ac86ec is the ID per MSFT
  principal_id         = var.aad_principal_id
}
*/
#create a database on the mssql server
resource "azurerm_mssql_database" "dbmssqldb" {
  name           = var.sqldb_name != null ? var.sqldb_name : "${var.use_name}${var.env}sqldb"
  server_id      = azurerm_mssql_server.dbmssqlsvr.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  #max_size_gb    = 4
  max_size_gb    = var.max_size_gb
  read_scale     = false #true for highly critical prod instances
  #sku_name       = "BC_Gen5_2" #need to research this to understand best options
  sku_name       = var.sql_sku_name
  zone_redundant = false #true for highly critical prod instances

  tags = merge(local.required_tags, var.custom_tags)
}

#testing whether this block successfully adds an AD group to an MSSQL database
resource "azurerm_sql_active_directory_administrator" "azsqladmin" {
  server_name         = azurerm_mssql_server.dbmssqlsvr.name
  resource_group_name = var.rg_name
  #login               = "sqladmin"
  #login               = "IT_DS_Admin"
  login               = var.aad_sqladmin_login
  tenant_id           = "eb83984f-99ea-46bb-be92-cca88ced3b85" #hardcoded tenant ID (shouldn't change for our deployments)
  object_id           = var.aad_sqladmin_id

 }

#create the db server extended audit policy
resource "azurerm_mssql_server_extended_auditing_policy" "dbmssqlsvrpol" {
  server_id                               = azurerm_mssql_server.dbmssqlsvr.id
  storage_endpoint                        = azurerm_storage_account.dbstore.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.dbstore.primary_access_key
  storage_account_access_key_is_secondary = true
  retention_in_days                       = 6

 }

#create the db extended audit policy
resource "azurerm_mssql_database_extended_auditing_policy" "dbmssqldbpol" {
  database_id                             = azurerm_mssql_database.dbmssqldb.id
  storage_endpoint                        = azurerm_storage_account.dbstore.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.dbstore.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6

}







/*
# Create a DB private endpoint
resource "azurerm_private_endpoint" "dbmssqlsvr_pe" {
  depends_on          = [azurerm_mssql_server.dbmssqlsvr]
  name                = "dbmssqlsvr_pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = data.terraform_remote_state_devspoke_snpe_id

  private_service_connection {
    name                           = "dbmssqlsvr_privcon"
    private_connection_resource_id = azurerm_mssql_server.dbmssqlsvr.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
}

# DB Private Endpoint Connecton
data "azurerm_private_endpoint_connection" "dbmssqlsvr_conn" {
  depends_on = [azurerm_private_endpoint.dbmssqlsvr_pe]
  name = azurerm_private_endpoint.dbmssqlsvr_pe.name
  resource_group_name = var.rg_name
}

# A private DNS zone and a DNS zone to VNET link need to be added to the spoke network in support of private endpoints
# They are both shown below but don't belong here
# Create a Private DNS Zone
resource "azurerm_private_dns_zone" "pe-private-dns" {
  name                = var.some-name
  resource_group_name = var.network-rg-name
}
# Link the Private DNS Zone with the VNET
resource "azurerm_private_dns_zone_virtual_network_link" "pe-private-dns-link" {
  name                  = "${var.some-spoke-vnet-name}-link"
  resource_group_name   = var.network-rg-name
  private_dns_zone_name = azurerm_private_dns_zone.pe-private-dns.name
  virtual_network_id    = azurerm_virtual_network.spoke-vnet-name.id
}


# Create a DB Private DNS A Record in the shared private DNS zone
resource "azurerm_private_dns_a_record" "dbmssqlsvr-pe-dns-a-record" {
  depends_on = [azurerm_mssql_server.dbmssqlsvr]
  name = lower(azurerm_mssql_server.dbmssqlsvr.name)
  zone_name = azurerm_private_dns_zone.pe-private-dns.name #or some output variable from the spoke_net construction
  resource_group_name = var.network-rg-name #or whatever is the proper reference to the network RG
  ttl = 300
  records = [data.azurerm_private_endpoint_connection.dbmssqlsvr_conn.private_service_connection.0.private_ip_address]
}


*/