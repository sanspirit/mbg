resource "azurerm_servicebus_namespace" "main" {
  name                = "sb-${var.client_prefix}-${var.environment}-${var.shortlocation}"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name

  sku      = var.servicebus_sku
  capacity = var.servicebus_capacity

  tags = {
    CreatedBy   = var.createdby
    CreatedWith = "Terraform"
    Environment = var.environment
  }
}

resource "azurerm_servicebus_namespace_authorization_rule" "sb_namespace_auth_rule" {
  name         = "event_processor_auth_rule"
  namespace_id = azurerm_servicebus_namespace.main.id

  listen = true
  send   = true
  manage = false
}