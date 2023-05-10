resource "azurerm_storage_account" "datalake" {
  name                      = "sa${var.client_prefix}${var.environment}${var.shortlocation}"
  resource_group_name       = azurerm_resource_group.apps.name
  location                  = azurerm_resource_group.apps.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  is_hns_enabled            = "true"
  enable_https_traffic_only = "true"
  min_tls_version           = "TLS1_2"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "datalakefilesystem" {
  name               = "eventsdl"
  storage_account_id = azurerm_storage_account.datalake.id

  properties = {
    #hello = "aGVsbG8="
  }
}

resource "azurerm_storage_table" "eventcorrelation" {
  name                 = "EventCorrelation"
  storage_account_name = azurerm_storage_account.datalake.name
}

resource "azurerm_storage_table" "eventstatus" {
  name                 = "EventStatus"
  storage_account_name = azurerm_storage_account.datalake.name
}

resource "azurerm_storage_table" "rulesengineworkflowsdefinitions" {
  name                 = "RulesEngineWorkflowsDefinitions"
  storage_account_name = azurerm_storage_account.datalake.name
}