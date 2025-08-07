resource "azurerm_public_ip" "pip" {
  count               = 3
  name                = "${var.humber_id}-pip${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  count               = 3
  name                = "${var.humber_id}-nic${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_managed_disk" "data_disk" {
  count                = 3
  name                 = "${var.humber_id}-vm${count.index + 1}-datadisk"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  tags                 = var.tags
}

variable "availability_set_id" {
  type        = string
  description = "ID of the availability set"
}


resource "azurerm_linux_virtual_machine" "vm" {
  count               = 3
  name                = "${var.humber_id}-vm${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
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

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  count              = 3
  managed_disk_id    = azurerm_managed_disk.data_disk[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm[count.index].id
  lun                = 0
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "custom_script" {
  count                = 3
  name                 = "${var.humber_id}-vm${count.index + 1}-custom-script"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  settings             = <<SETTINGS
    {
      "commandToExecute": "apt-get update && apt-get install -y apache2"
    }
  SETTINGS
  tags                 = var.tags
}

resource "azurerm_virtual_machine_extension" "monitoring" {
  count                = 3
  name                 = "${var.humber_id}-vm${count.index + 1}-monitoring"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Azure.Diagnostics"
  type                 = "LinuxDiagnostic"
  type_handler_version = "3.0"
  auto_upgrade_minor_version = true
  settings             = <<SETTINGS
    {
      "StorageAccount": "${var.humber_id}-diagnostics",
      "ladCfg": {
        "diagnosticMonitorConfiguration": {
          "eventVolume": "Medium",
          "metrics": {
            "metricAggregation": [
              {
                "scheduledTransferPeriod": "PT1M"
              }
            ]
          },
          "performanceCounters": {
            "performanceCounterConfiguration": [
              {
                "counterSpecifier": "/builtin/Processor/PercentProcessorTime",
                "sampleRate": "PT60S"
              }
            ]
          }
        }
      }
    }
  SETTINGS
  protected_settings    = <<PROTECTED_SETTINGS
    {
      "storageAccountName": "${var.humber_id}-diagnostics",
      "storageAccountKey": "${azurerm_storage_account.diagnostics.primary_access_key}"
    }
  PROTECTED_SETTINGS
  tags                 = var.tags
  depends_on           = [azurerm_storage_account.diagnostics]
}

output "public_ips" {
  value = azurerm_public_ip.pip[*].ip_address
}

output "nic_ids" {
  value = azurerm_network_interface.nic[*].id
}

output "vm_ids" {
  value = azurerm_linux_virtual_machine.vm[*].id
}
