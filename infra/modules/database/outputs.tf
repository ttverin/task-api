output "fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

output "server_name" {
  value = azurerm_postgresql_flexible_server.db.name
}

output "admin_login" {
  value = azurerm_postgresql_flexible_server.db.administrator_login
}

output "db_name" {
  value = azurerm_postgresql_flexible_server_database.db.name
}

