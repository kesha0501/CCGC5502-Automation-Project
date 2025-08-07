terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-6553"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.humber_id}storage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.humber_id}-container"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_availability_set" "avset" {
  name                        = "${var.humber_id}-avset"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.main.name
  platform_fault_domain_count = 2
  tags                        = var.tags
}

resource "azurerm_route_table" "route_table" {
  name                          = "${var.humber_id}-route-table"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.main.name
  tags                          = var.tags

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

resource "azurerm_route_table" "route_table2" {
  name                          = "${var.humber_id}-route-table2"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.main.name
  tags                          = var.tags

  route {
    name                   = "default2"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

module "networking" {
  source         = "./modules/networking"
  humber_id      = var.humber_id
  resource_group = azurerm_resource_group.main.name
  location       = var.location
  tags           = var.tags
}

module "vms" {
  source              = "./modules/vms"
  humber_id           = var.humber_id
  resource_group      = azurerm_resource_group.main.name
  location            = var.location
  tags                = var.tags
  subnet_id           = module.networking.subnet_id
  availability_set_id = azurerm_availability_set.avset.id
}

module "loadbalancer" {
  source         = "./modules/loadbalancer"
  humber_id      = var.humber_id
  resource_group = azurerm_resource_group.main.name
  location       = var.location
  tags           = var.tags
  vm_nic_ids     = module.vms.nic_ids
}

output "vm_public_ips" {
  value = module.vms.public_ips
}

output "load_balancer_fqdn" {
  value = module.loadbalancer.lb_fqdn
}
