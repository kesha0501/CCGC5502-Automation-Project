data "azurerm_public_ip" "vm" {
  count               = var.vm_count
  name                = "pip-vm-${var.project_prefix}-${count.index + 1}"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "main" {
  count               = var.vm_count
  name                = "nic-${var.project_prefix}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_ids[count.index]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_ids[count.index]
  }
  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "main" {
  count               = var.vm_count
  name                = "${var.project_prefix}-vm${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  tags = var.tags
}

resource "azurerm_managed_disk" "data" {
  count                = var.vm_count
  name                 = "${var.project_prefix}-data-disk-${count.index + 1}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  count              = var.vm_count
  managed_disk_id    = azurerm_managed_disk.data[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.main[count.index].id
  lun                = 0
  caching            = "ReadWrite"
}

resource "azurerm_network_interface_security_group_association" "main" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.main[count.index].id
  network_security_group_id = var.nsg_ids[count.index]
}
