resource "time_sleep" "wait_for_acr" {
  depends_on      = [azurerm_container_registry.acr]
  create_duration = "30s"
}
