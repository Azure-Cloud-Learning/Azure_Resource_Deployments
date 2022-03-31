terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    } 
  }
  required_version = ">=1.1.6"
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "asp" {
  name = var.resourceGroup
  location = var.location
}

resource "azurerm_app_service_plan" "asp" {
    name = var.asp_name
    resource_group_name = azurerm_resource_group.asp.name
    location = azurerm_resource_group.asp.location
    kind = var.asp_kind
    reserved = var.asp_reserved
    tags = var.tags
    sku {
      capacity = var.asp_sku.capacity
      size = var.asp_sku.size
      tier = var.asp_sku.tier
    }
    depends_on = [
      azurerm_resource_group.asp
    ]
}

resource "azurerm_app_service" "app" {
  name = var.app_name
  resource_group_name = azurerm_resource_group.asp.name
  location = azurerm_resource_group.asp.location
  app_service_plan_id = azurerm_app_service_plan.asp.id
  https_only = true
  tags = var.tags

  depends_on = [
    azurerm_app_service_plan.asp
  ]

  site_config {
    min_tls_version = "1.2"
    ftps_state = "Disabled"
    use_32_bit_worker_process = true #Must be true if using Free or Shared ASP tier.
  }


}