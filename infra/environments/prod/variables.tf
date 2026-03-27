variable "environment" {
  type    = string
  default = "prod"
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
  default = "Standard"
}

variable "db_sku" {
  type    = string
  default = "GP_Standard_D2s_v3"
}

variable "app_cpu" {
  type    = number
  default = 1.0
}

variable "app_memory" {
  type    = string
  default = "2Gi"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

