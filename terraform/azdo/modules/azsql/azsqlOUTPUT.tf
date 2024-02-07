output sa_id {
    value = azurerm_storage_account.dbstore.id
}
output dbsvr_id {
    value = azurerm_mssql_server.dbmssqlsvr.id
}
output db_id {
    value = azurerm_mssql_database.dbmssqldb.id
}