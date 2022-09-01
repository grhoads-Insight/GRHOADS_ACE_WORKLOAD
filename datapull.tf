data "azurerm_resource_group" "environment_rg" {
  for_each = var.env
  name     = "grhoads-rg-${each.value}"
}

data "azurerm_key_vault" "keyvault1" {
  for_each            = var.env
  name                = "grhoads-keyvault-${each.value}"
  resource_group_name = data.azurerm_resource_group.environment_rg["${each.value}"].name
}

data "azurerm_virtual_network" "vnet1" {
  for_each            = var.env
  name                = "grhoads-network-${each.value}"
  resource_group_name = data.azurerm_resource_group.environment_rg["${each.value}"].name
}

data "azurerm_subnet" "app-subnet" {
  for_each             = var.env
  name                 = "app-subnet-${each.value}"
  resource_group_name  = data.azurerm_resource_group.environment_rg["${each.value}"].name
  virtual_network_name = data.azurerm_virtual_network.vnet1["${each.value}"].name
}

data "azurerm_subnet" "data-subnet" {
  for_each             = var.env
  name                 = "data-subnet-${each.value}"
  resource_group_name  = data.azurerm_resource_group.environment_rg["${each.value}"].name
  virtual_network_name = data.azurerm_virtual_network.vnet1["${each.value}"].name
}

data "azurerm_subnet" "web-subnet" {
  for_each             = var.env
  name                 = "web-subnet-${each.value}"
  resource_group_name  = data.azurerm_resource_group.environment_rg["${each.value}"].name
  virtual_network_name = data.azurerm_virtual_network.vnet1["${each.value}"].name
}

data "azurerm_storage_account" "storage_account1" {
  for_each            = var.env
  name                = "grhoadslzstorage${each.value}"
  resource_group_name = data.azurerm_resource_group.environment_rg["${each.value}"].name
}

# data "azurerm_storage_container" "storage_container1" {
#   for_each = var.env  
#   name                 = "grhoadslzcontainer-${var.env}"
#   storage_account_name = data.azurerm_storage_account.storage_account1["${each.value}"].name
# }

# data "azurerm_storage_blob" "storage_blob1" {
#   for_each = var.env
#   name                   = "grhoadslzblob-${var.env}"
#   storage_account_name   = data.azurerm_storage_account.storage_account1["${each.value}"].name
#   storage_container_name = data.azurerm_storage_container.storage_container1["${each.value}"].name
# }