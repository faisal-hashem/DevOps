#Add a provider, with alias, for any spokes that will be modified
provider "azurerm" {
  alias = "spoke_azurerm"
  features {}
  subscription_id = var.spoke_subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.rglocation
  provider = azurerm.spoke_azurerm
}
