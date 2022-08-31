data "azurerm_resource_group" "rg1" {
  name = "landing_zone_rg"
}
data "azurerm_resource_group" "rg2" {
  name = "workload_rg"
}

data "azurerm_key_vault" "keyvault1" {
  name                = "landing-zone-keyvault"
  resource_group_name = data.azurerm_resource_group.rg1.name
}

data "azurerm_virtual_network" "vnet1" {
  name                = "landing-zone-network"
  resource_group_name = data.azurerm_resource_group.rg1.name
}

data "azurerm_subnet" "app-subnet" {
  name                 = "app-subnet"
  resource_group_name  = data.azurerm_resource_group.rg1.name
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
}

data "azurerm_subnet" "data-subnet" {
  name                 = "data-subnet"
  resource_group_name  = data.azurerm_resource_group.rg1.name
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
}

data "azurerm_subnet" "web-subnet" {
  name                 = "web-subnet"
  resource_group_name  = data.azurerm_resource_group.rg1.name
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
}

data "azurerm_storage_account" "storage_account1" {
  name                = "grhoadsacelzstorage"
  resource_group_name = data.azurerm_resource_group.rg1.name
}

data "azurerm_storage_container" "storage_container1" {
  name                 = "grhoadsacelzcontainer"
  storage_account_name = data.azurerm_storage_account.storage_account1.name
}

data "azurerm_storage_blob" "storage_blob1" {
  name                   = "grhoadsacelzblob"
  storage_account_name   = data.azurerm_storage_account.storage_account1.name
  storage_container_name = data.azurerm_storage_container.storage_container1.name
}