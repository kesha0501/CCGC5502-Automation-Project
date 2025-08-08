output "subnet_ids" {
  description = "List of subnet IDs"
  value       = azurerm_subnet.main[*].id
}

output "nsg_ids" {
  description = "List of network security group IDs"
  value       = azurerm_network_security_group.main[*].id
}

output "public_ip_ids" {
  description = "List of public IP IDs"
  value       = azurerm_public_ip.vm[*].id
}

output "lb_public_ip_id" {
  description = "Public IP ID for the load balancer"
  value       = azurerm_public_ip.lb.id
}
