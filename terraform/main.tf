locals {
  common_tags = {
    Project        = "CCGC 5502 Automation Project"
    Name           = "Kesha.Shah"
    ExpirationDate = "2024-12-31"
    Environment    = "Project"
  }
  project_prefix = "6553"
  vm_count      = 3
  vm_size       = "Standard_B1ms"
  location      = "canadacentral"
}

variable "admin_username" {
  description = "Administrator username for VMs"
  type        = string
  default     = "adminuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project_prefix}"
  location = local.location
  tags     = local.common_tags
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_prefix      = local.project_prefix
  vm_count            = local.vm_count
  tags                = local.common_tags
}

module "vms" {
  source              = "./modules/vms"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_prefix      = local.project_prefix
  vm_count            = local.vm_count
  vm_size             = local.vm_size
  admin_username      = var.admin_username
  ssh_public_key      = file(var.ssh_public_key_path)
  subnet_ids          = module.networking.subnet_ids
  nsg_ids             = module.networking.nsg_ids
  public_ip_ids       = module.networking.public_ip_ids
  tags                = local.common_tags
  depends_on          = [module.networking]
}

module "loadbalancer" {
  source              = "./modules/loadbalancer"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_prefix      = local.project_prefix
  vm_count            = local.vm_count
  network_interface_ids = module.vms.network_interface_ids
  lb_public_ip_id     = module.networking.lb_public_ip_id
  tags                = local.common_tags
  depends_on          = [module.vms]
}
	
resource "null_resource" "ansible_provisioner" {
  depends_on = [module.vms, module.loadbalancer]
  provisioner "local-exec" {
    command = "sleep 60 && ansible-playbook -i ../ansible/inventory.yml ../ansible/${local.project_prefix}-playbook.yml"
  }
  triggers = {
    vm_ids = join(",", module.vms.vm_ids)
  }
}
