resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
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
  subnet_id      = module.networking.subnet_id
  tags           = var.tags
}

module "loadbalancer" {
  source         = "./modules/loadbalancer"
  humber_id      = var.humber_id
  resource_group = azurerm_resource_group.main.name
  location       = var.location
  vm_nic_ids     = module.vms.nic_ids
  tags           = var.tags
}

resource "null_resource" "ansible_provisioner" {
  depends_on = [module.vms, module.loadbalancer]

  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook -i ${path.module}/ansible/inventory.yml ${path.module}/ansible/6553-playbook.yml
    EOT
  }
}
