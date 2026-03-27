resource "azurerm_resource_group" "rg" {
  name     = "rg-task-api-${var.environment}-weu"
  location = var.location
}

locals {
  db_server_name = "psql-task-api-${var.environment}-weu"
  db_url = join("", [
    "postgresql://",
    "psqladmin@psql-task-api-${var.environment}-weu",
    ":${var.postgres_password}",
    "@${module.database.fqdn}",
    ":5432/${module.database.db_name}?sslmode=require"
  ])
}

module "registry" {
  source              = "../../modules/registry"
  name                = "acrtaskapi${var.environment}weu"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
}

module "database" {
  source              = "../../modules/database"
  server_name         = local.db_server_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  admin_password      = var.postgres_password
  sku_name            = var.db_sku
}

module "keyvault" {
  source              = "../../modules/keyvault"
  name                = "kv-task-api-${var.environment}-weu"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  db_url              = local.db_url
}

module "app" {
  source              = "../../modules/app"
  name                = "task-api"
  law_name            = "law-taskapi-${var.environment}-weu"
  identity_name       = "task-api-identity-${var.environment}"
  cae_name            = "cae-taskapi-${var.environment}-weu"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  acr_login_server    = module.registry.login_server
  acr_id              = module.registry.id
  kv_id               = module.keyvault.id
  db_url              = local.db_url
  image_tag           = var.image_tag
  cpu                 = var.app_cpu
  memory              = var.app_memory
}

