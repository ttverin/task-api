variable "name" {
  type = string
}

variable "law_name" {
  type = string
}

variable "identity_name" {
  type = string
}

variable "cae_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "acr_login_server" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "kv_id" {
  type = string
}

variable "db_url" {
  type      = string
  sensitive = true
}

variable "image_name" {
  type    = string
  default = "task-api"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "cpu" {
  type    = number
  default = 0.5
}

variable "memory" {
  type    = string
  default = "1Gi"
}

variable "target_port" {
  type    = number
  default = 3000
}

