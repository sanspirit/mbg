resource "azurerm_storage_account" "itsmapistorage" {
  name                     = "sa${var.client_prefix}${var.environment}itsmapi${var.shortlocation}"
  resource_group_name      = azurerm_resource_group.apps.name
  location                 = azurerm_resource_group.apps.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "itsmapiplan" {
  name                = "asp${var.client_prefix}${var.environment}itsmapi${var.shortlocation}"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  os_type             = "Windows"
  sku_name            = "S1"
}

resource "azurerm_windows_web_app" "itsmapi" {
  name                = "wapi-${var.client_prefix}-${var.environment}-itsmapi-${var.shortlocation}"
  location            = azurerm_resource_group.apps.location
  resource_group_name = azurerm_resource_group.apps.name
  service_plan_id     = azurerm_service_plan.itsmapiplan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true
  }

  app_settings = {
    "ServiceNow:Instance"                   = var.snow_instance
    "ServiceNow:UserId"                     = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.snowuseridkey.name})"
    "ServiceNow:UserPassword"               = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.snowuserpasswordkey.name})"
    "ServiceNow:ClientId"                   = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.snowclientidkey.name})"
    "ServiceNow:Secret"                     = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.snowclientsecretkey.name})"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.main.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string
    "CICacheExpiryInMin"                    = 10
    "AccountCacheExpiryInMin"               = 240
    "IncidentCacheExpiryInMin"              = 10
    "ServiceNow:HttpRetryCount"             = 5
    "RedisConnection"                       = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.rediscacheconnectionkey.name})"
  }
}