resource "azurerm_service_plan" "app_plan1" {
    name = "app-service-plan-main"
    location = data.azurerm_resource_group.rg2.location
    resource_group_name = data.azurerm_resource_group.rg2.name
    os_type = "Linux"
    sku_name = "S1"
}

resource "azurerm_linux_web_app" "web_app1" {
    name = "web-app-main"
    resource_group_name = data.azurerm_resource_group.rg2.name
    location = data.azurerm_resource_group.rg2.location
    service_plan_id = azurerm_service_plan.app_plan1.id

    site_config {}
}

resource "azurerm_linux_function_app" "function_app1" {
    name = "function-app-main"
    resource_group_name = data.azurerm_resource_group.rg2.name
    location = data.azurerm_resource_group.rg2.location

    storage_account_name = data.azurerm_storage_account.storage_account1.name
    storage_account_access_key = data.azurerm_storage_account.storage_account1.primary_access_key
    service_plan_id = azurerm_service_plan.app_plan1.id

    site_config {}
}