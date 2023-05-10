resource "azurerm_key_vault" "main" {
  name                        = "kv-${var.client_prefix}-${var.environment}-core-${var.shortlocation}"
  location                    = azurerm_resource_group.core.location
  resource_group_name         = azurerm_resource_group.core.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = false
  sku_name                    = "premium"

  lifecycle {
    ignore_changes = [
      access_policy,
    ]
  }

  tags = {
    CreatedBy   = var.createdby
    CreatedWith = "Terraform"
    Environment = var.environment
  }

  access_policy {
    # enable the service principal that we are using to deploy from Azure DevOps
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "85881d32-f18b-46bc-834f-608a15c1212c"

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey"
    ]

    # Backup Delete Get List Purge Recover Restore Set
    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]

    certificate_permissions = [
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover",
      "Restore",
      "SetIssuers",
      "Update"
    ]

    storage_permissions = [
      "Backup",
      "Delete",
      "DeleteSAS",
      "Get",
      "GetSAS",
      "List",
      "ListSAS",
      "Purge",
      "Recover",
      "RegenerateKey",
      "Restore",
      "Set",
      "SetSAS",
      "Update"
    ]
  }
}

