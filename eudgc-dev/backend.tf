terraform {
  backend "azurerm" {
    storage_account_name = "eudgctfstate"
    container_name       = "eudgc-dev"
    key                  = "terraform.tfstate"

    use_azuread_auth = true
  }
}