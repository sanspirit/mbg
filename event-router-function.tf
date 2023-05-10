resource "azurerm_storage_account" "eventrouterstorage" {
  name                     = "sa${var.client_prefix}${var.environment}router${var.shortlocation}"
  resource_group_name      = azurerm_resource_group.apps.name
  location                 = azurerm_resource_group.apps.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "eventrouterplan" {
  name                = "asp${var.client_prefix}${var.environment}router${var.shortlocation}"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "eventrouterfunction" {
  name                       = "fa-${var.client_prefix}-${var.environment}-router-${var.shortlocation}"
  location                   = azurerm_resource_group.apps.location
  resource_group_name        = azurerm_resource_group.apps.name
  service_plan_id            = azurerm_service_plan.eventrouterplan.id
  storage_account_name       = azurerm_storage_account.eventrouterstorage.name
  storage_account_access_key = azurerm_storage_account.eventrouterstorage.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_insights_connection_string = azurerm_application_insights.main.connection_string
    application_insights_key               = azurerm_application_insights.main.instrumentation_key
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "",
    "StorageAccountName"       = azurerm_storage_account.datalake.name,
    "StorageAccountKey"        = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.datalakesaskey.name})",
    "StorageContainerName"     = azurerm_storage_data_lake_gen2_filesystem.datalakefilesystem.name,
    "SbConnection"             = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.sbnamespaceconnstring.name})",
    "ServiceNowInstance"       = var.snow_instance,
    "WEBSITE_CLOUD_ROLENAME"   = "EventRouter"
    "ProcessingMode"           = "true"
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}
