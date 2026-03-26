resource "azurerm_container_app" "app" {
  name                         = "task-api"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  secret {
    name                = "acr-username"
    key_vault_secret_id = azurerm_key_vault_secret.acr_username.id
    identity            = "system"
  }

  secret {
    name                = "acr-password"
    key_vault_secret_id = azurerm_key_vault_secret.acr_password.id
    identity            = "system"
  }

  registry {
    server               = azurerm_container_registry.acr.login_server
    username             = azurerm_key_vault_secret.acr_username.value
    password_secret_name = "acr-password"
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
      name   = "task-api"
      image  = "${azurerm_container_registry.acr.login_server}/task-api:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  depends_on = [
    azurerm_container_registry.acr,
    azurerm_key_vault_secret.acr_username,
    azurerm_key_vault_secret.acr_password,
    time_sleep.wait_for_acr
  ]
}
