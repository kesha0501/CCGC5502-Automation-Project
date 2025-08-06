variable "n01736553" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "vm_nic_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
