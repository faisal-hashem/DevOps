resource "azurerm_resource_policy_exemption" "sql_exemption" {
  count                = var.add_build_subnet || var.add_netskope_ips ? 1 : 0
  name                 = "sql-${var.use_name}-${var.env}-${var.region}-policy-exemption"
  display_name         = "sql-${var.use_name}-${var.env}-${var.region}-policy-exemption"
  resource_id          = var.resource_id
  policy_assignment_id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Authorization/policyAssignments/Public network access on Azure SQL Database disabled_Deny"
  exemption_category   = "Waiver"
}

resource "azurerm_mssql_server" "mssql_server" {
  name                         = "sql-${var.use_name}-${var.env}-${var.region}"
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login
  administrator_login_password = var.sql_administrator_login_password
  public_network_access_enabled = var.add_netskope_ips || var.add_build_subnet || var.fw_ip_ranges != null ? true : false
  depends_on = [ azurerm_resource_policy_exemption.sql_exemption ]
}

resource "azurerm_mssql_database" "db" {
  for_each       = var.database
  name           = each.key
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = each.value.collation
  license_type   = each.value.license_type
  max_size_gb    = each.value.max_size_gb
  read_scale     = each.value.read_scale
  sku_name       = each.value.sku_name
  zone_redundant = each.value.zone_redundant
  storage_account_type = each.value.storage_account_type
}

resource "azurerm_private_endpoint" "sql_privateendpoint" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pep-sql-${var.use_name}-${var.env}-${var.region}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id
  //tags                = merge(local.required_tags, var.custom_tags)

  private_service_connection {
  name                             = "con-ac-${var.use_name}-${var.env}-${var.region}"
    private_connection_resource_id = azurerm_mssql_server.mssql_server.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_name != null && var.private_dns_zone_ids != null ? [1]:[]
    content {
      name = var.private_dns_zone_name # != null ? var.private_dns_zone_name : null
      private_dns_zone_ids = var.private_dns_zone_ids # != null ? [var.private_dns_zone_ids] : null  
    }
  }
}

data "azurerm_private_dns_zone" "privatelink_database" {
  provider = azurerm.prodmgmt
  name                = "privatelink.database.windows.net"
  resource_group_name = "net_prodmgmt_${var.region}"
}

locals {
  rubrik_subnet_id = "/subscriptions/56b07343-7ecb-4de5-a101-5869d15f9619/resourceGroups/net_prodmgmt_${var.region}/providers/Microsoft.Network/virtualNetworks/mgmt_${var.region}_vnet_non_peered/subnets/rubrik_${var.region}_sn00"
}

resource "azurerm_private_endpoint" "sql_privateendpoint_rubrik" {
  provider            = azurerm.prodmgmt
  count               = var.enable_rubrik_endpoint ? 1 : 0
  name                = "pep-sql-rubrik-${var.use_name}-${var.env}-${var.region}"
  location            = var.location
  resource_group_name = "net_prodmgmt_${var.region}"
  subnet_id           = local.rubrik_subnet_id
  //tags                = merge(local.required_tags, var.custom_tags)

  private_service_connection {
  name                             = "con-ac-rubrik-${var.use_name}-${var.env}-${var.region}"
    private_connection_resource_id = azurerm_mssql_server.mssql_server.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
    private_dns_zone_group {
    name = data.azurerm_private_dns_zone.privatelink_database.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.privatelink_database.id]
  }
  
}

locals {
  netskope_ips = split("\r\n", file("../utility_scripts/resources/netskope_ips.txt"))
  fw_ip_ranges = (
    var.fw_ip_ranges != null && var.add_netskope_ips ? compact(concat(var.fw_ip_ranges, local.netskope_ips)) :
    var.fw_ip_ranges != null && var.add_netskope_ips == false ? var.fw_ip_ranges :
    var.fw_ip_ranges == null && var.add_netskope_ips ? local.netskope_ips : null
  )
  build_subnet_ids = split("\r\n", file("../utility_scripts/resources/build_subnet_ids.txt"))
}

resource "azurerm_mssql_firewall_rule" "fwrule" {
  for_each = local.fw_ip_ranges != null ? toset(local.fw_ip_ranges) : []
  name             = "${replace(each.key,"/","_")}"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = endswith(each.key, "/32") ? cidrhost(each.key, 0) : cidrhost(each.key, 1)
  end_ip_address   = cidrhost(each.key, -1)
}

resource "azurerm_mssql_virtual_network_rule" "build_agent_vnetrule" {
  #for_each = local.fw_ip_ranges != null ? toset(local.build_subnet_ids) : []
  for_each         = var.add_build_subnet || local.fw_ip_ranges != null ? { for k in local.build_subnet_ids : "${element(split("/", k), length(split("/", k))-1)}" => k } : {}
  name             = "${each.key}_vnet_rule"
  server_id        = azurerm_mssql_server.mssql_server.id
  subnet_id        = each.value
}