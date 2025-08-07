provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.humber_id}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_availability_set" "vm_as" {
  name                = "${var.humber_id}-as"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  tags                = var.tags
}

module "networking" {
  source         = "./modules/networking"
  humber_id      = var.humber_id
  location       = var.location
  resource_group = azurerm_resource_group.rg.name
  tags           = var.tags
}

module "vms" {
  source             = "./modules/vms"
  humber_id          = var.humber_id
  location           = var.location
  resource_group     = azurerm_resource_group.rg.name
  subnet_id          = module.networking.subnet_id
  availability_set_id = azurerm_availability_set.vm_as.id
  tags               = var.tags
}

module "loadbalancer" {
  source         = "./modules/loadbalancer"
  humber_id      = var.humber_id
  location       = var.location
  resource_group = azurerm_resource_group.rg.name
  vm_nic_ids     = module.vms.nic_ids
  tags           = var.tags
}

variable "humber_id" {
  default = "6553"
}

variable "location" {
  default = "canadacentral"
}

variable "tags" {
  default = {
    environment = "CCGC 5502 Automation Project"
    owner       = "n01736553"
  }
}

output "load_balancer_fqdn" {
  value = module.loadbalancer.lb_fqdn
}

output "vm_public_ips" {
  value = module.vms.public_ips
}
