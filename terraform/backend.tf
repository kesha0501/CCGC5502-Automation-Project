terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg-6553"
    storage_account_name = "tfstate6553sa"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
