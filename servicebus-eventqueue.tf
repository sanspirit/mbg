resource "azurerm_servicebus_queue" "event_message_queue" {
  name         = "event-message"
  namespace_id = azurerm_servicebus_namespace.main.id
}

resource "azurerm_servicebus_queue_authorization_rule" "event_message_queue_auth_rule" {
  name     = "event_message_auth_rule"
  queue_id = azurerm_servicebus_queue.event_message_queue.id

  listen = true
  send   = true
  manage = false
}
