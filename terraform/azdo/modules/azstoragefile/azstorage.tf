locals {
  saname = var.name != "" && length(var.name) > 1 ? lower(var.name) : "${var.use_name}${var.env}f1"
  required_tags = {
    environment     = var.env
    TFModifiedTime  = "${formatdate("YYYYMMDD_hhmmss ZZZ", timestamp())}"
    CreationMethod  = "Terraform"
  }
  share_config = flatten([ for share, attrib in var.storage_share_config: [ for role, groups in attrib.roles: [ for group in groups: { share = share, role = role, group = group } ] ] ])
  netskope_ips = split("\r\n", file("../utility_scripts/resources/netskope_ips.txt"))
  build_subnet_ids = split("\r\n", file("../utility_scripts/resources/build_subnet_ids.txt"))
}

# This data call will run a PowerShell script to create the AD Computer Account if the terraform action is Apply, otherwise will just look for computer account
data "external" "powershell_test" {
  program = ["pwsh", "../utility_scripts/powershell/Create-ADStorageAccount.ps1"]  # Need to figure out relative path

  query = {
    saname = local.saname
  }
}

resource "azurerm_storage_account" "storagefileaccount" {
  name                     = var.name != "" && length(var.name) > 1 ? lower(var.name) : "${var.use_name}${var.env}f1"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  tags                     = merge(local.required_tags, var.custom_tags)
  min_tls_version          = "TLS1_2"

  
      azure_files_authentication {
        directory_type = "AD"
        active_directory  {
                            domain_name = "na.mycompany.com"
                            netbios_domain_name = "FHM" 
                            forest_name = "mycompany.com"
                            domain_guid = "ef1a0af7-3011-40fb-be58-c5cada37a667"
                            domain_sid = "S-1-5-21-790133437-1943092204-507081533"
                            storage_sid = "${data.external.powershell_test.result.sid}"
        }
      }  
  depends_on = [data.external.powershell_test]
}

# This resource will call a script to add kerberos keys on the newly created Storage Account and set the AD Machine Account password to the first kerberos key.
resource "null_resource" "set_ad_storage_key" {
  triggers = {
      sid = data.external.powershell_test.result.sid
      name = azurerm_storage_account.storagefileaccount.name
  }
  provisioner "local-exec" {
      command     = "../utility_scripts/powershell/Set-ADStorageKey.ps1 -rgname ${var.rg_name} -saname ${azurerm_storage_account.storagefileaccount.name}"
      interpreter = ["pwsh", "-Command"]
  }
  depends_on = [azurerm_storage_account.storagefileaccount, data.external.powershell_test]
}

#
# This resource is a Private Endpoint setup for Storage Accounts
#
resource "azurerm_private_endpoint" "storagefile_privateendpoint" {
  name                = "${azurerm_storage_account.storagefileaccount.name}-privend"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${azurerm_storage_account.storagefileaccount.name}-peservconn"
    private_connection_resource_id = azurerm_storage_account.storagefileaccount.id
    is_manual_connection           = false
    subresource_names              = ["File"]
  }

}

  #
  # This resource is a setup for Storage Account Network rules
  # It cannot be combined with inline blocks for network rules, within a storage account setup
  # 
  resource "azurerm_storage_account_network_rules" "storageaccountrules" {
    storage_account_id   = azurerm_storage_account.storagefileaccount.id
    default_action       = "Deny"
    virtual_network_subnet_ids = var.acl_subnet_ids != null ? compact(concat(var.acl_subnet_ids, local.build_subnet_ids)) : local.build_subnet_ids
    ip_rules             = var.acl_allowed_ips != null ? compact(concat(var.acl_allowed_ips, local.netskope_ips)) : local.netskope_ips
  }

  # 

resource "azurerm_storage_share" "storagefileshare2" {
  for_each             = var.storage_share_config
  name                 = each.key
  storage_account_name = azurerm_storage_account.storagefileaccount.name
  quota                = each.value.quota
}

resource "azurerm_role_assignment" "share_permissions" { 
  for_each = { for i, record in local.share_config : md5("${record.share}${record.role}${record.group}") => record }
  scope = azurerm_storage_share.storagefileshare2[each.value.share].resource_manager_id 
  role_definition_name = each.value.role 
  principal_id = each.value.group 
  depends_on = [azurerm_storage_share.storagefileshare2]
} 
 

  resource "azurerm_role_assignment" "storageact_role" {
    for_each = { for i, record in var.storage_account_permission : i => record if length(var.storage_share_config) > 0 }  # For each is set to for loop to allow for null valued roles
    #for_each             = var.storage_account_roles
    scope                = azurerm_storage_account.storagefileaccount.id
    role_definition_name = each.value #var.azure_role  #Storage File Data SMB Share Contributor
    principal_id         = each.key #var.aad_principal_id
  }  

# This resource will send an e-mail informing team members to manually create a DNS Entry for the new storage account
resource "null_resource" "send_dns_information" {
  triggers = {
    ip = azurerm_private_endpoint.storagefile_privateendpoint.private_service_connection[0].private_ip_address
    name = azurerm_storage_account.storagefileaccount.name
  }
  provisioner "local-exec" {
    command     = "Send-MailMessage -smtpserver \"smtpinternal.DOMAIN.com\" -To \"USER@DOMAIN.com\",\"USER@DOMAIN.com\",\"USER@DOMAIN.com\" -From \"AZStorageFile_NoReply@DOMAIN.com\" -Subject \"Create DNS Entry for AD Joined Storage Account - ${azurerm_storage_account.storagefileaccount.name}\" -Body \"Create a new DNS Entry for the following: ${azurerm_storage_account.storagefileaccount.primary_file_endpoint} - ${azurerm_private_endpoint.storagefile_privateendpoint.private_service_connection[0].private_ip_address}\""
    interpreter = ["PowerShell", "-Command"]
  }
  
  depends_on = [azurerm_private_endpoint.storagefile_privateendpoint]
}


/*
  resource "azurerm_role_assignment" "share_read_only" {
    scope                 = azurerm_storage_share.storagefileshare.id
    role_definition_name  = "Storage File Data SMB Share Reader"
    principal_id          = var.share_principal_id_ro
  }
  */

  /*
data "external" "finalize_storageaccount" {
  program = ["pwsh", "../utility_scripts/powershell/Set-ADStorageAccountKey.ps1"]
  #program = ["pwsh", "./.terraform/modules/storagefile/azstoragefile/Set-ADStorageAccountKey.ps1"]  # Need to update this to utility_scripts path once tested and committed

  query = {
    saname = azurerm_storage_account.storagefileaccount.name
    thycoticusername = var.thycoticusername
    thycoticpassword = var.thycoticpassword
    thycoticSecret = 1477
    tfaction = var.tfaction
    tfspappid = var.tfspappid
    tfspsecret = var.tfspsecret
    rgname = var.rg_name
    subscription_id = var.subscription_id
    }
  
  depends_on = [azurerm_storage_account.storagefileaccount, data.external.powershell_test]
}
*/


  # 
  # This section does the role-assignments for the Storage Account
  #data "azurerm_role_definition" "storage_role" {
  #name = "Storage File Data SMB Share Contributor"
  #"Storage File Data SMB Share Reader" 

  #
  /*
  resource "azurerm_role_assignment" "storageact_role" {
    scope                = azurerm_storage_account.storagefileaccount.id
    role_definition_name = var.azure_role  #Storage File Data SMB Share Contributor
    principal_id         = var.aad_principal_id
  }
*/

/*
resource "azurerm_role_assignment" "share_permissions" {
    for_each = [for share, attrib in var.storage_share_config: [for role, group in attrib.roles: {role = role, group = group}]]
    scope                 = azurerm_storage_share.storagefileshare2[each.key].id
    role_definition_name  = each.value.role
    principal_id          = each.value.group
  }
*/
/*
resource "azurerm_role_assignment" "share_permissions" { 
  for_each = merge(flatten([ for share, attrib in var.storage_share_config : { for role, group in attrib.roles : md5("${role}${group}") => { share = share, role = role, group = group } } ])...) 
  scope = azurerm_storage_share.storagefileshare2[each.value.share].resource_manager_id 
  role_definition_name = each.value.role 
  principal_id = each.value.group 
  depends_on = [azurerm_storage_share.storagefileshare2]
} 
*/

  #
  #resource "azurerm_storage_share" "storagefileshare" {
  #//  name               = "${var.use_name}${var.env}share"
  #  name                 = var.sharefolder_name
  #  storage_account_name = azurerm_storage_account.storagefileaccount.name
  #  quota                = var.quota_in_gb
  #}

    # This resource creates a File-share under the Storage Account

/*
    resource "azurerm_storage_share" "storagefileshare" {
    for_each = var.storage_share_settings
    name                 = each.key
    storage_account_name = azurerm_storage_account.storagefileaccount.name
    quota                = each.value
  }
*/

