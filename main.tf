resource "azurerm_service_plan" "app_plan1" {
    name = var.app_service_plan_name
    location = data.azurerm_resource_group.rg2.location
    resource_group_name = data.azurerm_resource_group.rg2.name
    os_type = "Linux"
    sku_name = "S1"
}

resource "azurerm_linux_web_app" "web_app1" {
    name = var.web_app_name
    resource_group_name = data.azurerm_resource_group.rg2.name
    location = data.azurerm_resource_group.rg2.location
    service_plan_id = azurerm_service_plan.app_plan1.id

    site_config {}
}

resource "azurerm_linux_function_app" "function_app1" {
    name = var.function_app_name
    resource_group_name = data.azurerm_resource_group.rg2.name
    location = data.azurerm_resource_group.rg2.location

    storage_account_name = data.azurerm_storage_account.storage_account1.name
    storage_account_access_key = data.azurerm_storage_account.storage_account1.primary_access_key
    service_plan_id = azurerm_service_plan.app_plan1.id

    site_config {}
}

resource "azurerm_log_analytics_workspace" "log_space_1" {
    name = var.log_space_name
    location = data.azurerm_resource_group.rg2.location
    resource_group_name = data.azurerm_resource_group.rg2.name
    sku = "PerGB2018"
    retention_in_days = 30
}

resource "azurerm_cosmosdb_account" "cosmosdb_1" {
    name = var.cosmosDB-name
    location = data.azurerm_resource_group.rg2.location
    resource_group_name = data.azurerm_resource_group.rg2.name
    offer_type = "Standard"
    kind = "MongoDB"

    #add geo-location for redundancy
}

resource "azurerm_cosmosdb_sql_database" "sql_database1" {
    name = var.sql_database_name
    resource_group_name = azurerm_cosmosdb_account.cosmosdb_1.resource_group_name
    account_name = azurerm_cosmosdb_account.cosmosdb_1.name
    throughput = 400
}
#create cosmosDB account and SQL database account