variable "n01736553" {
  type    = string
  default = "6553"
}

variable "resource_group_name" {
  type    = string
  default = "rg-6553"
}

variable "location" {
  type    = string
  default = "CanadaCentral"
}

variable "tags" {
  type = map(string)
  default = {
    Project        = "CCGC 5502 Automation Project"
    Name           = "Kesha Shah"
    ExpirationDate = "2024-12-31"
    Environment    = "Project"
  }
}
