resource "azurerm_api_management_logger" "premium-logger" {
  api_management_name = azurerm_api_management.premium.name
  resource_group_name = azurerm_api_management.premium.resource_group_name
  name                = "logger"

  resource_id = azurerm_application_insights.main.id

  application_insights {
    instrumentation_key = azurerm_application_insights.main.instrumentation_key
  }
}
