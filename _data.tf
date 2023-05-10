data "azurerm_client_config" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

data "azurerm_function_app_host_keys" "evtprochostkeys" {
  name                = azurerm_linux_function_app.eventprocfunction.name
  resource_group_name = azurerm_linux_function_app.eventprocfunction.resource_group_name
}
