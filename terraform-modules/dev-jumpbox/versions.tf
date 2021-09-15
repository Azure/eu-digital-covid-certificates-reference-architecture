terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.71.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "=3.1.0"
    }
  }
  required_version = ">= 1.0"
}
