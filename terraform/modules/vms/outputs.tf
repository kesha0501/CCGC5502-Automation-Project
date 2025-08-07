output "nic_ids" {
  value = azurerm_network_interface.nic[*].id
}

output "public_ips" {
  value = azurerm_public_ip.vm_pip[*].ip_address
}
