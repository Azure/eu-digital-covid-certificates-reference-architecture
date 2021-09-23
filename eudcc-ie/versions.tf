terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.71.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=1.6.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "=1.11.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "=2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.4.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "=3.1.0"
    }
  }
  required_version = ">= 1.0"
}
