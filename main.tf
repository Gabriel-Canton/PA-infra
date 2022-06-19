terraform {
  backend "azurerm" {
    storage_account_name = "hack"
    container_name       = "pu-infra"
    key                  = "terraform.tfstate"
    # Traté de sacar esto de acá y ponerlo como variable pero no me deja usar vars acá (no sé por qué)
    access_key = "snVh+5xM4ZJ1Qmh6hrRlZo3t9oTJSPvIE0h8PHfUqwSGttZaW6rOJv4ghbA59WTHWzCoM671ncmD+AStw7ghQw=="
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  client_id       = "e3b2c5e3-975d-4b5b-bb93-25f8b36c8ec7"
  subscription_id = "a06ea5c9-35d5-42a7-b5cf-9d69fbfc20c9"
  tenant_id       = "c912770d-be52-40ca-9d40-77536a8b2f67"
  client_secret   = var.svc_acct_key
}
/*
locals {
  region1 = "eastus2"
  region2 = "centralus"
  rg1     = "resource-group-1"
  rg2     = "resource-group-2"
}
*/
module "HA_resources" {
  source = "./Modules/HA resources"
  # Los nombres de los App Service tienen que ser globalmente únicos
  RESOURCES = [
    {
      app_insights_name     = "app-insights-1"
      app_service_name      = "app-svc-lkjsg-1"
      app_service_plan_name = "app-service-plan-1"
      location              = var.main_region
      resource_group_name   = var.RESOURCE_GROUP_NAMES[0]
    },
    {
      app_insights_name     = "app-insights-2"
      app_service_name      = "app-svc-lkajsw-2"
      app_service_plan_name = "app-service-plan-2"
      location              = var.secondary_region
      resource_group_name   = var.RESOURCE_GROUP_NAMES[1]
    }
  ]
  /*LOCATION = local.region1
  RESOURCE_GROUP = "resource-group-1"
  APP_INSIGHTS_NAME = "PU-app-insights-1"
  APP_SVC_PLAN_NAME = "PU-app-svc-plan-1"
  APP_SVC_NAME = "PU-app-svc-1"
  */
}
/*
resource "azurerm_resource_group" "RG-1" {
  location = local.region1
  name     = "resource-group-1"
}

resource "azurerm_resource_group" "RG-2" {
  location = local.region2
  name     = "resource-group-2"
}
*/

/*resource "azurerm_app_service_plan" "AppServicePlan-1" {
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
*/

/*
module "app_service" {
  source       = "./Modules/AppService"
  AS_plan_name = "app-service-plan-1"
  AS_plan_sku  = { tier = "Standard", size = "S1" }
  AS_name      = "hack-app-service-1"
  AS_location  = local.region1
  AS_RG        = azurerm_resource_group.RG-1.name
}
*/

resource "azurerm_mssql_server" "SQLserver" {
  name                         = "hack-sql-server"
  location                     = var.main_region
  resource_group_name          = module.HA_resources.resource-group-names[0]
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sqladmin_pass
}

resource "azurerm_log_analytics_workspace" "LogAnalyticsWorkspace" {
  name                = "lga-workspace"
  resource_group_name = module.HA_resources.resource-group-names[0]
  location            = var.main_region
}

resource "azurerm_log_analytics_solution" "LogAnalyticsSolution" {
  # Nota: este nombre tiene que ser el mismo que va en product después de la /, si no te tira un error incomprensible (https://github.com/Azure/azure-rest-api-specs/issues/9672)
  solution_name         = "AzureActivity"
  resource_group_name   = module.HA_resources.resource-group-names[0]
  location              = var.main_region
  workspace_resource_id = azurerm_log_analytics_workspace.LogAnalyticsWorkspace.id
  workspace_name        = azurerm_log_analytics_workspace.LogAnalyticsWorkspace.name
  plan {
    publisher      = "Microsoft"
    product        = "OMSGallery/AzureActivity"
    promotion_code = "Maxi"
  }
}