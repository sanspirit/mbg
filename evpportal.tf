resource "azurerm_storage_account" "evpportalstorage" {
  name                     = "sa${var.client_prefix}${var.environment}evpportal${var.shortlocation}"
  resource_group_name      = azurerm_resource_group.apps.name
  location                 = azurerm_resource_group.apps.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "evpportalplan" {
  name                = "asp${var.client_prefix}${var.environment}evpportal${var.shortlocation}"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  os_type             = "Windows"
  sku_name            = "S1"
}

resource "azurerm_windows_web_app" "evpportalwebapp" {
  name                = "wapp-${var.client_prefix}-${var.environment}-evpportal-${var.shortlocation}"
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
    "DefaultDaysToSearch"                   = "-7"
    "AzureAd:ClientId"                      = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.evpportalazureadclientid.name})"
    "AzureAd:ClientSecret"                  = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.evpportalazureadclientsecret.name})"
    "AzureAd:Domain"                        = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.evpportalazureaddomain.name})"
    "AzureAd:TenantId"                      = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.evpportalazureadtenantid.name})"
    "AzureAd:Instance"                      = "https://login.microsoftonline.com/"
    "AzureAd:CallbackPath"                  = "/signin-oidc"
    "EVPDataApi:BaseUrl"                    = "https://${azurerm_windows_web_app.evpdataapi.name}.azurewebsites.net/api"
    "EVPDataApi:Scopes"                     = "api://f14f64aa-7cb2-46a9-8aec-7347756f09c6/user_read"
  }
}