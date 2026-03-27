variable "environment" {
  type    = string
  default = "staging"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "acr_sku" {
  type    = string
  default = "Basic"
}

variable "db_sku" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "app_cpu" {
  type    = number
  default = 0.25
}

variable "app_memory" {
  type    = string
  default = "0.5Gi"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

