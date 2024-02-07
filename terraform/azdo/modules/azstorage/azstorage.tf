locals {
  required_tags = {
    environment     = var.env
    TFModifiedTime  = "${formatdate("YYYYMMDD_hhmmss ZZZ", timestamp())}"
    CreationMethod  = "Terraform"
  }
  netskope_ips = split("\r\n", file("../utility_scripts/resources/netskope_ips.txt"))
  build_subnet_ids = split("\r\n", file("../utility_scripts/resources/build_subnet_ids.txt"))
  container_config = var.container_config != "" ? flatten([ for container, attrib in var.container_config: [ for role, groups in attrib.roles: [ for group in groups: { container = container, role = role, group = group } ] ] ]) : null  # This will structure container configuration if the calling module is passing in var.container_config, otherwise will be null

}


resource "azurerm_storage_account" "storage_account" {
  name                     = var.name != "" && length(var.name) > 1 ? lower(var.name) : "st${var.use_name}${var.env}${var.region}"
  resource_group_name      = var.rg_name
  location                 = var.location
  is_hns_enabled           = var.namespace_enabled
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  min_tls_version          = "TLS1_2"
  tags                     = merge(local.required_tags, var.custom_tags)

  network_rules { 
    default_action = var.acl_allowed_ips != null || var.acl_subnet_ids != null || var.add_netskope_ips ? "Deny" : "Allow"              # If any network configuration is supplied, this will default to Deny rather than Allow.
    bypass         = var.acl_bypass
      ip_rules       = (
         var.acl_allowed_ips != null && var.add_netskope_ips == false ? var.acl_allowed_ips :                                          # If acl_allowed_ips were supplied but add_netskope_ips is false, this will add in the acl_allowed_ips to ip_rules
         var.acl_allowed_ips == null && var.add_netskope_ips ? local.netskope_ips :                                                    # If add_netskope_ips is true but acl_supplied_ips is null, the netskope IPs will be supplied to ip_rules
         var.acl_allowed_ips != null && var.add_netskope_ips ? compact(concat(var.acl_allowed_ips, local.netskope_ips)) : null         # If add_netskope_ips is true AND acl_supplied_ips were supplied, those values will be concatenated and supplied to ip_rules
      )                                                                                                                                # If none of these conditions were met, the ip_rules block will be null and default_action will be Allow
      virtual_network_subnet_ids = (
          var.acl_subnet_ids != null ? compact(concat(local.build_subnet_ids, var.acl_subnet_ids)) :                                   # If acl_subnet_ids are supplied, the list of subnets will be concatenated with the build agent subnets. One virtual_networks_rules block per subnet supplied will be created
         (var.add_netskope_ips || var.acl_allowed_ips != null) && var.acl_subnet_ids == null ? compact(local.build_subnet_ids) : null  # If add_netskope_ips is true OR acl_allowed_ips were supplied AND no additional subnet IDs, this will add the build agent subnet IDs by default
      )                                                                                                                                # If none of the conditions were met, this will evalute to null
  }

  blob_properties {
    delete_retention_policy {
        days = var.delete_retention_policy_days
    }
    versioning_enabled     = var.versioning_enabled
  }
}

resource "azurerm_private_endpoint" "private_endpoint_blob" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pep-st-${var.use_name}-${var.env}-${var.region}"
  location            = var.location
  resource_group_name = var.rg_name
  #subnet_id           = var.enable_private_endpoint ? var.subnet_id : null 
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "con-st-${var.use_name}-${var.env}-${var.location}"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["Blob"]
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_container" "container" {
  for_each             = { for k, v in var.container_config: k => v if length(var.container_config) > 0}
  name                 = each.key
  storage_account_name = azurerm_storage_account.storage_account.name
  container_access_type = each.value.type
}

resource "azurerm_role_assignment" "container_permissions" { 
  for_each = { for i, record in local.container_config : md5("${record.container}${record.role}${record.group}") => record if length(var.container_config) > 0 }
  scope = azurerm_storage_container.container[each.value.container].resource_manager_id 
  role_definition_name = each.value.role 
  principal_id = each.value.group 
  depends_on = [azurerm_storage_container.container]
} 