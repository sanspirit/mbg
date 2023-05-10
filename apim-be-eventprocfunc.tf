resource "azurerm_api_management_backend" "event-proc-func-be" {
  name                = "EventProcFuncHttps"
  resource_group_name = azurerm_api_management.main.resource_group_name
  api_management_name = azurerm_api_management.main.name
  protocol            = "http"
  url                 = "https://${azurerm_linux_function_app.eventprocfunction.name}.azurewebsites.net/api/"

  description = "APIM Backend for the Event Processor function app."

  credentials {
    header = {
      "x-functions-key" = "{{${azurerm_api_management_named_value.evtprocfunchostkey.name}}}"
    }
  }
}