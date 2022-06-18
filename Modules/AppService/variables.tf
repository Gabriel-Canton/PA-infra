variable "AS_plan_name" {
  description = "App Service plan name"
}

/* This section was moved to the modules variables.tf
variable "AS_plan_location" {
  description = "App Service plan location"
}

variable "AS_plan_RG" {
  description = "App Service plan Resource Group name"
}
*/
variable "AS_plan_sku" {
  description = "App Service plan SKU"
  type        = object({ tier = string, size = string })
}

variable "AS_name" {
  description = "App Service name"
}

variable "AS_location" {
  description = "App Service location"
}

variable "AS_RG" {
  description = "App Service Resource Group name"
}