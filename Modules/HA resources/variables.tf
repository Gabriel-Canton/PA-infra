variable "RESOURCES" {
  type = list(object({ location = string, resource_group_name = string, app_insights_name = string, app_service_plan_name = string, app_service_name = string }))
}
/*
variable "LOCATION" {
  description = "Location where to deploy HA resources"
}

variable "RESOURCE_GROUP" {
  description = "Name of the Resource Group to create"
}

variable "APP_INSIGHTS_NAME" {
  description = "Application Insights name"
}

variable "APP_SVC_PLAN_NAME" {
  description = "App Service Plan name"
}

variable "APP_SVC_NAME" {
  description = "App Service name"
}
*/