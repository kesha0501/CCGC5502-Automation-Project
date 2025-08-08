variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "project_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs"
  type        = number
}

variable "network_interface_ids" {
  description = "List of network interface IDs"
  type        = list(string)
}

variable "lb_public_ip_id" {
  description = "ID of the public IP for the load balancer"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
