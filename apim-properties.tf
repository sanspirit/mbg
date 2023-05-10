resource "azurerm_api_management_named_value" "eventqueuesaskey" {
  name                = "eventqueuesaskey"
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_api_management.main.resource_group_name
  display_name        = "eventqueuesaskey"
  secret              = true

  value_from_key_vault {
    secret_id = azurerm_key_vault_secret.eventqueuesaskey.id
  }
}

resource "azurerm_api_management_named_value" "servicebusqueueendpoint" {
  name                = "servicebusqueueendpoint"
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_api_management.main.resource_group_name
  display_name        = "servicebusqueueendpoint"
  value               = "https://${azurerm_servicebus_namespace.main.name}.servicebus.windows.net/${azurerm_servicebus_queue.event_message_queue.name}"
  # follow: https://github.com/hashicorp/terraform-provider-azurerm/issues/15306 for when a property of the queue object will yield this endpoint?
}
resource "azurerm_api_management_named_value" "evtprocfunchostkey" {
  name                = "evt-proc-func-host-key"
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_api_management.main.resource_group_name
  display_name        = "evt-proc-func-host-key"
  value               = data.azurerm_function_app_host_keys.evtprochostkeys.default_function_key
}