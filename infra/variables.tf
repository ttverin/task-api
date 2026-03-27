variable "postgres_password" {
  type = string
}

locals {
  db_user     = "psqladmin@psql-task-api-dev-weu"
  db_host     = "psql-task-api-dev-weu.postgres.database.azure.com"
  db_name     = "taskdb"

  db_password_encoded = urlencode(var.postgres_password)

  database_url = "postgres://${local.db_user}:${local.db_password_encoded}@${local.db_host}:5432/${local.db_name}?sslmode=require"
}
