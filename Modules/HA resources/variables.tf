variable "RESOURCES" {
  type = list(object({ location = string, resource_group_name = string, app_insights_name = string, app_service_plan_name = string, app_service_name = string }))
}