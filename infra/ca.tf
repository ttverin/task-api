resource "azurerm_container_app" "app" {
  name                         = "task-api"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id

  revision_mode = "Single"

  # Secret
  secret {
    name  = "database-url"
    value = "postgresql://psqladmin@psql-task-api-dev-weu:${var.postgres_password}@psql-task-api-dev-weu.postgres.database.azure.com:5432/taskdb?sslmode=require"
  }

  # Identity
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
  }

  # Registry
  registry {
    server   = azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.uai.id
  }

  ingress {
    external_enabled = true
    target_port      = 3000

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name  = "task-api"
      image = "${azurerm_container_registry.acr.login_server}/task-api:latest"

      cpu    = 0.5
      memory = "1Gi"

      env {
        name        = "DATABASE_URL"
        secret_name = "database-url"
      }
    }
  }

  # IMPORTANT: ensures RBAC is ready
  depends_on = [
    azurerm_role_assignment.acr_pull
  ]
}
