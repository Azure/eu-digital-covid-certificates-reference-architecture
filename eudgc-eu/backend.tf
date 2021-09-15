terraform {
  backend "azurerm" {
    storage_account_name = "eudgctfstate"
    container_name       = "eudgc-eu"
    key                  = "terraform.tfstate"

    use_azuread_auth = true
  }
}