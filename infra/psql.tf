resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "psql-task-api-dev-weu"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location

  administrator_login    = "psqladmin"
  administrator_password = var.postgres_password

  sku_name = "B_Standard_B1ms"
  version  = "14"

  storage_mb = 32768

  lifecycle {
    ignore_changes = [
      high_availability,
      zone
    ]
  }

}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "taskdb"
  server_id = azurerm_postgresql_flexible_server.db.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
