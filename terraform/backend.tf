terraform {
  required_version = ">=0.12.21"

  backend "azurerm" {
    resource_group_name  = "AvansInfra"
    storage_account_name = "avansstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
