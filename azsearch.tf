resource "azurerm_search_service" "instance" {
  name                = "azsearch-${var.client_prefix}-${var.environment}-${var.shortlocation}"
  resource_group_name = azurerm_resource_group.apps.name
  location            = azurerm_resource_group.apps.location
  sku                 = "basic"
  identity {
    type = "SystemAssigned"
  }
}