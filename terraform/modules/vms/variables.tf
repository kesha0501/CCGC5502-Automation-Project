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

variable "vm_size" {
  description = "Size of the VMs"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for VMs"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VMs"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "nsg_ids" {
  description = "List of network security group IDs"
  type        = list(string)
}

variable "public_ip_ids" {
  description = "List of public IP IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
