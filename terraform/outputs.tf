output "vm_public_ips" {
  value = module.vms.vm_public_ips
}

output "load_balancer_fqdn" {
  value = module.loadbalancer.load_balancer_fqdn
}
