resource "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
}

resource "azurerm_user_assigned_identity" "uai" {
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = var.kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}

resource "time_sleep" "wait_for_rbac" {
  depends_on      = [azurerm_role_assignment.acr_pull]
  create_duration = "30s"
}

resource "azurerm_container_app_environment" "env" {
  name                       = var.cae_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

resource "azurerm_container_app" "app" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.env.id

  revision_mode = "Single"

  secret {
    name  = "database-url"
    value = var.db_url
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
  }

  registry {
    server   = var.acr_login_server
    identity = azurerm_user_assigned_identity.uai.id
  }

  ingress {
    external_enabled = true
    target_port      = var.target_port

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = var.name
      image  = "${var.acr_login_server}/${var.image_name}:${var.image_tag}"
      cpu    = var.cpu
      memory = var.memory

      env {
        name        = "DATABASE_URL"
        secret_name = "database-url"
      }
    }
  }

  depends_on = [time_sleep.wait_for_rbac]
}

