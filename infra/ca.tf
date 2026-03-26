resource "azurerm_container_app" "app" {
  name                         = "task-api"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  registry {
      server   = azurerm_container_registry.acr.login_server
      username = azurerm_container_registry.acr.admin_username
      password_secret_name = "acr-password"
    }

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.acr.admin_password
  }

  ingress {
    external_enabled = true
    target_port      = 3000

    traffic_weight {
      percentage = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "task-api"
      image  = "acrtaskapidevweu.azurecr.io/task-api:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

}