/*
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  backend "azurerm" {
  }

  required_version = ">= 1.1.7"
}
*/
provider "azurerm" {
  features {}
}

##Uncomment this only when making statefile repairs, and comment out the backend block above.
#
# # Dev Backend
#
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-mbgevp-tfstate"
    storage_account_name = "mbgevpdevtfstate"
    container_name       = "mbgevp-dev"
    key                  = "mbgevp-base.terraform.tfstate"
  }
}
