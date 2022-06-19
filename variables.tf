variable "svc_acct_key" {
  description = "Secret para la cuenta de servicio para Terraform en Azure"
  sensitive   = true
}

variable "sqladmin_pass" {
  description = "Pass de la cuenta de administración del SQL Server"
  sensitive   = true
}

variable "main_region" {
  description = "First HA region that holds the database"
}

variable "secondary_region" {
  description = "Second HA region"
}

variable "RESOURCE_GROUP_NAMES" {
  description = "Names of the Resource Groups to create, one for each region"
  type = list(string)
}