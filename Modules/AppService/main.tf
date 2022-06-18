resource "azurerm_app_service_plan" "AppServicePlan" {
  name = var.AS_plan_name
  location = var.AS_location
  resource_group_name = var.AS_RG
  sku {
    tier = var.AS_plan_sku.tier
    size = var.AS_plan_sku.size
  }
}

resource "azurerm_app_service" "AppService" {
  name = var.AS_name
  location = var.AS_location
  resource_group_name = var.AS_RG
  app_service_plan_id = azurerm_app_service_plan.AppServicePlan.id

  site_config {}
}

