variable "name" {
  type        = string
  description = "Key Vault name — 3-24 chars, alphanumeric and hyphens"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "db_url" {
  type      = string
  sensitive = true
}

