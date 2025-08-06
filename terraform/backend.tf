terraform {
  backend "azurerm" {
    resource_group_name  = "rg-6553-state"
    storage_account_name = "6553tfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
