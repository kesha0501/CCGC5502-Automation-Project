resource "azurerm_resource_group" "main" {
  name     = "rg-6553"
  location = var.location
  tags     = var.tags
}

module "networking" {
  source         = "./modules/networking"
  humber_id      = var.humber_id
  resource_group = azurerm_resource_group.main.name
  location       = var.location
  tags           = var.tags
}

module "vms" {
  source         = "./modules/vms"
  humber_id      = var.humber_id
  resource_group = azurerm_resource_group.main.name
  location       = var.location
  tags           = var.tags
  subnet_id      = module.networking.subnet_id
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
