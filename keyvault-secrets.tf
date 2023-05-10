resource "azurerm_key_vault_secret" "eventqueuesaskey" {
  name         = "eventqueuesaskey"
  value        = azurerm_servicebus_queue_authorization_rule.event_message_queue_auth_rule.primary_key
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_servicebus_queue_authorization_rule.event_message_queue_auth_rule
  ]
}

resource "azurerm_key_vault_secret" "sbnamespaceconnstring" {
  name         = "sbnamespaceconnstring"
  value        = azurerm_servicebus_namespace_authorization_rule.sb_namespace_auth_rule.primary_connection_string
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_servicebus_namespace_authorization_rule.sb_namespace_auth_rule
  ]
}

resource "azurerm_key_vault_secret" "datalakesaskey" {
  name         = "datalakesaskey"
  value        = azurerm_storage_account.datalake.primary_access_key
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_storage_account.datalake
  ]
}

resource "azurerm_key_vault_secret" "snowuseridkey" {
  name         = "snowuseridkey"
  value        = var.snow_userid
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "snowuserpasswordkey" {
  name         = "snowuserpasswordkey"
  value        = var.snow_userpassword
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "snowclientidkey" {
  name         = "snowclientidkey"
  value        = var.snow_clientid
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "snowclientsecretkey" {
  name         = "snowclientsecret"
  value        = var.snow_clientsecret
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "itsmclientid" {
  name         = "itsmclientid"
  value        = var.itsm_clientid
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "itsmsecret" {
  name         = "itsmsecret"
  value        = var.itsm_secret
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "evptableconnectionstring" {
  name         = "evptableconnectionstring"
  value        = azurerm_storage_account.datalake.primary_connection_string
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_storage_account.datalake
  ]
}

resource "azurerm_key_vault_secret" "evpportalazureadclientid" {
  name         = "evpportal-azuread-clientid"
  value        = var.evpportal_azuread_clientid
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "evpportalazureadclientsecret" {
  name         = "evpportal-azuread-clientsecret"
  value        = var.evpportal_azuread_clientsecret
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "evpportalazureaddomain" {
  name         = "evpportal-azuread-domain"
  value        = var.evpportal_azuread_domain
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "evpportalazureadtenantid" {
  name         = "evpportal-azuread-tenantid"
  value        = var.evpportal_azuread_tenantid
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "appinsightappid" {
  name         = "mainappinsightappid"
  value        = azurerm_application_insights.main.app_id
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "evpappinsight_clientid" {
  name         = "evpappinsightclientid"
  value        = var.evpappinsight_clientid
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "evpappinsight_clientsecret" {
  name         = "evpappinsightclientsecret"
  value        = var.evpappinsight_clientsecret
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "evpappinsight_clienttenant" {
  name         = "evpappinsightclienttenant"
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "secureapisubscriptionkey" {
  name         = "secureapisubscriptionkey"
  value        = azurerm_api_management_subscription.SecureSubscription.primary_key
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "azuresearchsecureapiskey" {
  name         = "azuresearchsecureapiskey"
  value        = azurerm_search_service.instance.primary_key
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "rediscacheconnectionkey" {
  name         = "rediscacheconnectionkey"
  value        = azurerm_redis_cache.rediscache.primary_connection_string
  key_vault_id = azurerm_key_vault.main.id
}