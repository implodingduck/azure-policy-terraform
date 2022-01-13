terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.83.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

resource "azurerm_management_group" "mg" {
  display_name = "mg-tfdemo"
}

data "azurerm_policy_set_definition" "builtin" {
  display_name = "NIST SP 800-53 Rev. 5"
}

resource "azurerm_management_group_policy_assignment" "example" {
  name                 = "NIST-SP-800-53-Rev-5"
  location             = "East US"
  policy_definition_id = data.azurerm_policy_set_definition.builtin.id
  management_group_id  = azurerm_management_group.mg.id
  identity {
    type = "SystemAssigned"
  }
}