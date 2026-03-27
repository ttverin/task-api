resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "psql-task-api-dev-weu"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location

  administrator_login    = "psqladmin"
  administrator_password = "SuperSecurePassword123!" # move to secret later

  sku_name   = "B_Standard_B1ms"
  version    = "14"

  storage_mb = 32768

  zone = "1"
}
