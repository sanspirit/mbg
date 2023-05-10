resource "azurerm_key_vault_access_policy" "itsmapi_kv_access_policy" {
  key_vault_id = azurerm_key_vault.main.id

  tenant_id = azurerm_windows_web_app.itsmapi.identity[0].tenant_id
  object_id = azurerm_windows_web_app.itsmapi.identity[0].principal_id

  key_permissions = [
    "Get",
    "List"
  ]

  secret_permissions = [
    "Get",
    "List"
  ]

  depends_on = [
    azurerm_key_vault.main,
    azurerm_windows_web_app.itsmapi
  ]
}
