resource "azurerm_resource_group" "apps" {
  name     = "RG-${upper(var.client_prefix)}-${upper(var.environment)}-APPS-${upper(var.shortlocation)}"
  location = var.location
  tags = {
    CreatedBy   = var.createdby
    CreatedWith = "Terraform"
    Environment = var.environment
  }
}

resource "azurerm_resource_group" "core" {
  name     = "RG-${upper(var.client_prefix)}-${upper(var.environment)}-CORE-${upper(var.shortlocation)}"
  location = var.location
  tags = {
    CreatedBy   = var.createdby
    CreatedWith = "Terraform"
    Environment = var.environment
  }
}
