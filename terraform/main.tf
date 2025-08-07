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

resource "azurerm_storage_account" "diagnostics" {
  name                     = "${var.humber_id}diagnostics"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  name                       = "${var.humber_id}-vm-diagnostics"
  target_resource_id         = module.vms.vm_ids[0]
  storage_account_id         = azurerm_storage_account.diagnostics.id
  log {
    category = "AuditEvent"
    enabled  = true
  }
  metric {
    category = "AllMetrics"
    enabled  = true
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
