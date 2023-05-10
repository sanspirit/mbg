resource "azurerm_windows_web_app" "evpdataapi" {
  name                = "wapi-${var.client_prefix}-${var.environment}-evpdataapi-${var.shortlocation}"
  location            = azurerm_resource_group.apps.location
  resource_group_name = azurerm_resource_group.apps.name
  service_plan_id     = azurerm_service_plan.evpportalplan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.main.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string
    "IndexSearchServiceApiKey"              = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.azuresearchsecureapiskey.name})"
    "EveventStatusIndexName"                = local.eventstatus_index_name
    "EventCorrelationIndexName"             = local.eventcorrelation_index_name
    "EventDataLakeIndexName"                = local.eventsdl_index_name
    "IndexServiceName"                      = azurerm_search_service.instance.name
    "DefaultDaysToSearch"                   = "-7"
    "ServiceNow:Instance"                   = var.snow_instance
    "ServiceNow:UserId"                     = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.snowuseridkey.name})"
    "ServiceNow:UserPassword"               = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.snowuserpasswordkey.name})"
    "ServiceNow:ClientId"                   = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.snowclientidkey.name})"
    "ServiceNow:Secret"                     = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.snowclientsecretkey.name})"
    "StorageConnectionString"               = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.evptableconnectionstring.name})"
  }
}