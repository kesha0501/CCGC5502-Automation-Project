resource "azurerm_public_ip" "vm_pip" {
  count               = 3
  name                = "${var.humber_id}-vm-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  count               = 3
  name                = "${var.humber_id}-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = 3
  name                = "${var.humber_id}-vm${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]
  availability_set_id = var.availability_set_id
  tags                = var.tags

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
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
}
