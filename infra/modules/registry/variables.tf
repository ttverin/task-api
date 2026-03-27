variable "name" {
  type        = string
  description = "ACR name — must be globally unique, lowercase alphanumeric only"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  type    = string
  default = "Basic"
}

