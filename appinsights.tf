resource "azurerm_application_insights" "main" {
  name                = "ai-${var.client_prefix}-${var.environment}-core-${var.shortlocation}"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  application_type    = "web"

  tags = {
    CreatedBy   = var.createdby
    CreatedWith = "Terraform"
    Environment = var.environment
  }
}