provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-6553"
  location = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

module "vms" {
  source         = "./modules/vms"
  resource_group = azurerm_resource_group.rg.name
  location       = var.location
  subnet_id      = module.network.subnet_id
  humber_id      = "6553"
  tags           = {
    environment = "dev"
    project     = "CCGC5502"
  }
}

module "loadbalancer" {
  source         = "./modules/loadbalancer"
  resource_group = azurerm_resource_group.rg.name
  location       = var.location
  humber_id      = "6553"
  tags           = {
    environment = "dev"
    project     = "CCGC5502"
  }
  vm_nic_ids     = module.vms.nic_ids
}

output "vm_public_ips" {
  value = module.vms.public_ips
}

output "load_balancer_fqdn" {
  value = module.loadbalancer.lb_fqdn
}
