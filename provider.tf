provider "panos" {
  hostname = var.fw_ip
  username = var.username
  password = var.password
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.59.0"
    }
    random = {
      source = "hashicorp/random"
    }
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "1.8.3"
    }

  }
  required_version = ">= 0.13"
}
provider "azurerm" {
  features {}
}
