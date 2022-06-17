variable "svc_acct_key" {
  description = "Secret para la cuenta de servicio para Terraform"
  sensitive   = true
}

variable "sqladmin_pass" {
  description = "Pass de la cuenta de administración del SQL Server"
  sensitive   = true
}