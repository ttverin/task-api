resource "azurerm_container_app" "app" {
  name                         = "task-api"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id

  revision_mode = "Single"

  # 🔐 Identity (critical)
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
  }

  # 🔐 Registry (NO PASSWORDS)
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
    }
  }

  # 🧠 IMPORTANT: ensures RBAC is ready
  depends_on = [
    azurerm_role_assignment.acr_pull
  ]
}
