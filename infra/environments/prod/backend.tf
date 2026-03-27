terraform {
  backend "azurerm" {
    resource_group_name  = "taskapi-tfstate-rg"
    storage_account_name = "taskapitfstatep72q4"
    container_name       = "tfstate"
    key                  = "taskapi-prod.tfstate"
  }
}

