resource "azurerm_container_app_environment" "env" {
  name                = "cae-taskapi-dev-weu"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}