terraform {
  backend "azurerm" {
    storage_account_name = "hack"
    container_name = "pu-infra"
    key = "terraform.tfstate"
    # Traté de sacar esto de acá y ponerlo como variable pero no me deja usar vars acá (no sé por qué)
    access_key = "snVh+5xM4ZJ1Qmh6hrRlZo3t9oTJSPvIE0h8PHfUqwSGttZaW6rOJv4ghbA59WTHWzCoM671ncmD+AStw7ghQw=="
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id = "e3b2c5e3-975d-4b5b-bb93-25f8b36c8ec7"
  subscription_id = "a06ea5c9-35d5-42a7-b5cf-9d69fbfc20c9"
  tenant_id = "c912770d-be52-40ca-9d40-77536a8b2f67"
  client_secret = var.svc_acct_key
}

locals {
  region1 = "eastus2"
  region2 = "centralus"
}

 resource "azurerm_resource_group" "RG-1" {
  location = local.region1
  name = "resource-group-1"
}

resource "azurerm_resource_group" "RG-2" {
  location = local.region2
  name = "resource-group-2"
}

resource "azurerm_app_service_plan" "AppServicePlan-1" {
  name = "app-service-plan-1"
  location = local.region1
  resource_group_name = azurerm_resource_group.RG-1.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "AppService-1" {
  name = "hack-app-service-1"
  location = local.region1
  resource_group_name = azurerm_resource_group.RG-1.name
  app_service_plan_id = azurerm_app_service_plan.AppServicePlan-1.id

  site_config {}
}

resource "azurerm_mssql_server" "SQLserver" {
  name = "hack-sql-server"
  location = local.region1
  resource_group_name = azurerm_resource_group.RG-1.name
  version = "12.0"
  administrator_login = "sqladmin"
  administrator_login_password = var.sqladmin_pass
}

resource "azurerm_log_analytics_workspace" "LogAnalyticsWorkspace" {
  name = "lga-workspace"
  resource_group_name = azurerm_resource_group.RG-1.name
  location = local.region1
}

resource "azurerm_log_analytics_solution" "LogAnalyticsSolution" {
  # Nota: este nombre tiene que ser el mismo que va en product después de la /, si no te tira un error incomprensible (https://github.com/Azure/azure-rest-api-specs/issues/9672)
  solution_name = "AzureActivity"   
  resource_group_name = azurerm_resource_group.RG-1.name
  location = local.region1
  workspace_resource_id = azurerm_log_analytics_workspace.LogAnalyticsWorkspace.id
  workspace_name = azurerm_log_analytics_workspace.LogAnalyticsWorkspace.name
  plan {
    publisher = "Microsoft"
    product = "OMSGallery/AzureActivity"
    promotion_code = "Maxi"
  }
}