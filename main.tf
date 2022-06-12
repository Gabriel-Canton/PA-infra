terraform {
  backend "azurerm" {
    storage_account_name = "hack"
    container_name = "pu-infra"
    key = "terraform.tfstate"
    access_key = "snVh+5xM4ZJ1Qmh6hrRlZo3t9oTJSPvIE0h8PHfUqwSGttZaW6rOJv4ghbA59WTHWzCoM671ncmD+AStw7ghQw=="
  }
}

