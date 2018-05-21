provider "azurerm" {
}

resource "azurerm_resource_group" "my_azurerm_resource_group" {
    name     = "${var.resource_group_name}"
    location = "${var.location}"
}

data "azurerm_client_config" "current" {}

resource "random_id" "server" {
  keepers = {
    ami_id = 1
  }
  byte_length = 8
}

resource "azurerm_storage_account" "test" {
  name                     = "${format("%s%s", "stor", random_id.server.hex)}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

}


resource "azurerm_container_registry" "test" {
  name                = "${format("%s%s", "reg", random_id.server.hex)}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  admin_enabled       = true
  sku                 = "Classic"
  storage_account_id  = "${azurerm_storage_account.test.id}"

 }
