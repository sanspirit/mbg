resource "azurerm_api_management" "main" {

  name                = "apim-${var.client_prefix}-${var.environment}-${var.shortlocation}"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  publisher_name      = "New Signature"
  publisher_email     = "newsig-tech@newsignature.com"

  sku_name = var.apimanagment_sku

  identity {
    type = "SystemAssigned"
  }

  sign_up {
    enabled = false
    terms_of_service {
      enabled          = false
      consent_required = false
    }
  }

  tags = {
    CreatedBy   = var.createdby
    CreatedWith = "Terraform"
    Environment = var.environment
  }
}
