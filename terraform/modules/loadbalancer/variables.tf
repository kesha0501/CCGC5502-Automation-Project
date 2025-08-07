variable "humber_id" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vm_nic_ids" {
  type = list(string)
}
