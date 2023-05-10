resource "azurerm_api_management_api_diagnostic" "receive-logger" {
  identifier               = "applicationinsights"
  resource_group_name      = azurerm_api_management.main.resource_group_name
  api_management_name      = azurerm_api_management.main.name
  api_name                 = azurerm_api_management_api.events.name
  api_management_logger_id = azurerm_api_management_logger.logger.id

  sampling_percentage       = 100
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "verbose"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  frontend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }

  /*  backend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  backend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }*/
}