variable "humber_id" {
  type        = string
  description = "Humber ID for naming resources"
}

variable "resource_group" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet"
}

variable "availability_set_id" {
  type        = string
  description = "ID of the availability set"
}

variable "storage_account_id" {
  type        = string
  description = "ID of the storage account for diagnostics"
}
