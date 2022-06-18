resource "azurerm_resource_group" "RES-GRPS" {
  count = length(var.RESOURCES)
  location = var.RESOURCES[count.index].location
  name     = var.RESOURCES[count.index].resource_group_name
}

module "app_service" {
  count = length(var.RESOURCES)
  source       = "../AppService"
  AS_plan_name = var.RESOURCES[count.index].app_service_plan_name
  AS_plan_sku  = { tier = "Standard", size = "S1" }
  AS_name      = var.RESOURCES[count.index].app_service_name
  AS_location  = var.RESOURCES[count.index].location
  AS_RG        = var.RESOURCES[count.index].resource_group_name
}

resource "azurerm_application_insights" "APP_INSIGHTS_NAME" {
  count = length(var.RESOURCES)
  name = var.RESOURCES[count.index].app_insights_name
  location = var.RESOURCES[count.index].location
  resource_group_name = var.RESOURCES[count.index].resource_group_name
  application_type = "web"
}