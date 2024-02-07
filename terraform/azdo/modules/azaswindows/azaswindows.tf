resource "azurerm_windows_web_app" "thisappservice" {
    name                = "app-${var.use_name}-${var.env}-${var.region}"
    location            = var.location
    resource_group_name = var.rg_name
    service_plan_id     = var.asp_id
    client_affinity_enabled = true
    app_settings = var.app_settings
    site_config {
        application_stack {
          current_stack = var.current_stack
          dotnet_version = var.current_stack == "dotnet" ? var.dotnet_version : null # Can be v2.0, v3.0, core3.1, v4.0, v6.0
        }
    }
    lifecycle {
      ignore_changes = [app_settings["WEBSITE_RUN_FROM_PACKAGE"]]
    }
    
    identity{
        type = var.identity_type
        identity_ids = [var.identity_ids]
      }
}

resource "azurerm_role_assignment" "app_role" {
  scope                = azurerm_windows_web_app.thisappservice.id
  role_definition_name = var.azure_role
  principal_id         = var.aad_principal_id
}

resource "azurerm_windows_web_app_slot" "appslot" {
  #for_each = toset(var.slot_names) 
  #name     = each.value
  count = var.slot_count
  name = "slot-${count.index}"
  app_service_id = azurerm_windows_web_app.thisappservice.id
  app_settings = var.app_settings
  lifecycle {
    ignore_changes = [app_settings["WEBSITE_RUN_FROM_PACKAGE"]]
  }
  identity{
    type = var.identity_type
    identity_ids = [var.identity_ids]
  }

  site_config {}
}