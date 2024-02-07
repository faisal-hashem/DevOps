resource "azurerm_app_service_environment_v3" "asev3" {
  name                = "asev3-${var.use_case}-${var.env}-${var.region}-${var.instance}"
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  internal_load_balancing_mode = "Web, Publishing"

  cluster_setting {
    name  = "DisableTls1.0"
    value = "1"
  }

  cluster_setting {
    name  = "InternalEncryption"
    value = "true"
  }

  cluster_setting {
    name  = "FrontEndSSLCipherSuiteOrder"
    value = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
  }

  timeouts {
    create = "12h"
    update = "12h"
    read  =  "60m"
  }

  tags = {
    env         = var.env
  }
}