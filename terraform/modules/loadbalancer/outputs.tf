output "load_balancer_id" {
  description = "Load balancer ID"
  value       = azurerm_lb.main.id
}

output "public_ip_address" {
  description = "Public IP address of the load balancer"
  value       = data.azurerm_public_ip.lb.ip_address
}

output "fqdn" {
  description = "FQDN of the load balancer"
  value       = data.azurerm_public_ip.lb.fqdn
}

output "backend_pool_id" {
  description = "Backend address pool ID"
  value       = azurerm_lb_backend_address_pool.main.id
}
