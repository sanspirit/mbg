
resource "azurerm_servicebus_queue" "azure_alert_queue" {
  name               = "azure-alert"
  namespace_id       = azurerm_servicebus_namespace.main.id
  max_delivery_count = 5
}
