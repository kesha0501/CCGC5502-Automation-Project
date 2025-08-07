variable "humber_id" {
  type    = string
  default = "6553"
  description = "Humber ID for naming resources"
}

variable "location" {
  type    = string
  default = "canadacentral"
  description = "Azure region for resources"
}

variable "tags" {
  type    = map(string)
  default = {
    environment = "CCGC5502"
    project     = "Automation"
  }
  description = "Tags for resources"
}
