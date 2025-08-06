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
  source              = "./modules/vms"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = module.network.subnet_id
  admin_username      = "adminuser"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
}

module "loadbalancer" {
  source              = "./modules/loadbalancer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vm_nic_ids          = module.vms.nic_ids
}

output "vm_public_ips" {
  value = module.vms.public_ips
}

output "load_balancer_fqdn" {
  value = module.loadbalancer.lb_fqdn
}
