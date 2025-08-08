output "vm_ids" {
  description = "List of VM IDs"
  value       = azurerm_linux_virtual_machine.main[*].id
}

output "network_interface_ids" {
  description = "List of network interface IDs"
  value       = azurerm_network_interface.main[*].id
}

output "public_ip_addresses" {
  description = "List of public IP addresses"
  value       = data.azurerm_public_ip.vm[*].ip_address
}

output "private_ip_addresses" {
  description = "List of private IP addresses"
  value       = azurerm_network_interface.main[*].private_ip_address
}

output "vm_fqdns" {
  description = "List of VM FQDNs"
  value       = data.azurerm_public_ip.vm[*].fqdn
}
