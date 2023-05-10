resource "azurerm_storage_account" "eventprocstorage" {
  name                     = "sa${var.client_prefix}${var.environment}proc${var.shortlocation}"
  resource_group_name      = azurerm_resource_group.apps.name
  location                 = azurerm_resource_group.apps.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "eventprocplan" {
  name                = "asp${var.client_prefix}${var.environment}eventproc${var.shortlocation}"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "eventprocfunction" {
  name                       = "fa-${var.client_prefix}-${var.environment}-eventproc-${var.shortlocation}"
  location                   = azurerm_resource_group.apps.location
  resource_group_name        = azurerm_resource_group.apps.name
  service_plan_id            = azurerm_service_plan.eventprocplan.id
  storage_account_name       = azurerm_storage_account.eventprocstorage.name
  storage_account_access_key = azurerm_storage_account.eventprocstorage.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_insights_connection_string = azurerm_application_insights.main.connection_string
    application_insights_key               = azurerm_application_insights.main.instrumentation_key
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"             = "",
    "SbConnection"                         = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.sbnamespaceconnstring.name})",
    "EventProcessorEventStorageConnection" = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.evptableconnectionstring.name})"
    "EventProcessorCorrelationPeriodInMin" = 1440,
    "WEBSITE_CLOUD_ROLENAME"               = "EventProcessor",
    "ITSMHost"                             = var.itsm_host,
    "ITSMTenantId"                         = "a1a2578a-8fd3-4595-bb18-7d17df8944b0",
    "ITSMClientId"                         = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.itsmclientid.name})",
    "ITSMSecret"                           = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.itsmsecret.name})",
    "ITSMScope"                            = "api://75b2b7ec-bbec-4520-9dd2-f156bb416fe7/.default",
    "ITSMIncidentAssignmentGroup"          = "962d9845db7a2b041b1518df4b96197f",
    "ITSMIncidentCallerId"                 = "9d5de9e5930022005bc5f179077ffb07",
    "ITSMIncidentImpact"                   = "1",
    "ITSMIncidentUrgency"                  = "2",
    "ITSMIncidentCategory"                 = "Alert",
    "ITSMInciduentSubCategory"             = "Azure",
    "ITSMIncidentContactType"              = "Alert",
    "MaxManifestPeriodHours"               = 168
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}