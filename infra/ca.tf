resource "azurerm_container_app" "app" {
  name                         = "task-api"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  ingress {
    external_enabled = true
    target_port      = 3000

    traffic_weight {
      percentage = 100
      latest_revision = true
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
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