output "vm_public_ips" {
  value = azurerm_public_ip.pip[*].ip_address
}

output "nic_ids" {
  value = azurerm_network_interface.nic[*].id
}
