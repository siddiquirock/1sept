resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = var.address_space   #["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}
