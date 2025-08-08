output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vm_public_ips" {
  description = "Public IPs of the VMs"
  value       = module.networking.public_ip_ids[*]
}

output "vm_private_ips" {
  description = "Private IP addresses of VMs"
  value       = module.vms.private_ip_addresses
}

output "vm_fqdns" {
  description = "FQDNs of VMs"
  value       = module.vms.vm_fqdns
}

output "load_balancer_public_ip" {
  description = "Load balancer public IP address"
  value       = module.loadbalancer.public_ip_address
}

output "load_balancer_fqdn" {
  description = "Load balancer FQDN"
  value       = module.loadbalancer.fqdn
}

output "ssh_connection_commands" {
  description = "SSH commands to connect to VMs"
  value = [
    for i in range(length(module.vms.public_ip_addresses)) :
    "ssh -i ~/.ssh/id_rsa adminuser@${module.vms.public_ip_addresses[i]}"
  ]
}

output "load_balancer_url" {
  description = "Load balancer HTTP URL"
  value       = "http://${module.loadbalancer.public_ip_address}"
}

output "loadbalancer_public_ip" {
  description = "Public IP of the load balancer"
  value       = module.networking.lb_public_ip_id
}
