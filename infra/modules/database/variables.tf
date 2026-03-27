variable "server_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_login" {
  type    = string
  default = "psqladmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "pg_version" {
  type    = string
  default = "14"
}

variable "storage_mb" {
  type    = number
  default = 32768
}

variable "db_name" {
  type    = string
  default = "taskdb"
}

