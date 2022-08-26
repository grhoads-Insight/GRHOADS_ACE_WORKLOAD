data "azurerm_resource_group" "rg1" {
    name = "landing_zone_rg"
}
data "azurerm_resource_group" "rg2" {
    name = "workload_rg"
}

data "azurerm_key_vault" "keyvault1" {
    name = "landing-zone-keyvault"
}

data "azurerm_virtual_network" "vnet1" {
    name = "landing-zone-network"
}

data "azurerm_subnet" "subnet1" {
    name = "app-subnet"
}

data "azurerm_subnet" "subnet2" {
    name = "data-subnet"
}

data "azurerm_subnet" "subnet3" {
    name = "web-subnet"
}

data "azurerm_storage_account" "storage_account1" {
    name = "grhoadsacelzstorage"
}

data "azurerm_storage_container" "storage_container1" {
    name = "grhoadsacelzcontainer"
}

data "azurerm_storage_blob" "storage_blob1" {
    name = "grhoadsacelzblob"
}