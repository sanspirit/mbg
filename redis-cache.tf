# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "rediscache" {
  name                = "redis-${var.client_prefix}-${var.environment}-core-${var.shortlocation}"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  capacity            = 2
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  redis_version       = "6"
  redis_configuration {

  }

  tags = {
    CreatedBy   = var.createdby
    CreatedWith = "Terraform"
    Environment = var.environment
  }
}