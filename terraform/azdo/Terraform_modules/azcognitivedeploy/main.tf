resource "azurerm_cognitive_deployment" "azcogdeploy" {
  name                 = "${var.model_name}-${var.use_name}-${var.env}"
  cognitive_account_id = var.account_id
  model {
    format  = var.model_format
    name    = var.model_name
    version = var.model_version
  }

  scale {
    type = var.deploy_scale
  }
}