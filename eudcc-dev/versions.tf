terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.71.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "=1.11.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "=2.1.0"
    }
  }
  required_version = ">= 1.0"
}
