resource "azurerm_service_plan" "webapp_serviceplan" {
  name                = var.webapp_service_plan_name
  resource_group_name = data.azurerm_resource_group.rg2.name
  location            = data.azurerm_resource_group.rg2.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_service_plan" "functionapp_serviceplan" {
  name                = var.functionapp_service_plan_name
  resource_group_name = data.azurerm_resource_group.rg2.name
  location            = data.azurerm_resource_group.rg2.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}
resource "azurerm_linux_web_app" "web_app1" {
  name                = var.web_app_name
  resource_group_name = data.azurerm_resource_group.rg2.name
  location            = data.azurerm_resource_group.rg2.location
  service_plan_id     = azurerm_service_plan.webapp_serviceplan.id

  site_config {}
}

resource "azurerm_app_service_virtual_network_swift_connection" "swift_appservice" {
  app_service_id = azurerm_linux_web_app.web_app1.id
  subnet_id      = data.azurerm_subnet.web-subnet.id
}

resource "azurerm_function_app" "azure_functionapp1" {
  name                = var.function_app_name
  resource_group_name = data.azurerm_resource_group.rg2.name
  location            = data.azurerm_resource_group.rg2.location
  app_service_plan_id = azurerm_service_plan.functionapp_serviceplan.id
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1",
    "FUNCTIONS_WORKER_RUNTIME"    = "node",
    "AzureWebJobsDisableHomepage" = "true",
  }
  os_type = "linux"
  site_config {
    linux_fx_version          = "node|14"
    use_32_bit_worker_process = false
  }
  storage_account_name       = data.azurerm_storage_account.storage_account1.name
  storage_account_access_key = data.azurerm_storage_account.storage_account1.primary_access_key
  version                    = "~3"
}

resource "azurerm_app_service_virtual_network_swift_connection" "swift_function" {
  app_service_id = azurerm_function_app.azure_functionapp1.id
  subnet_id      = data.azurerm_subnet.app-subnet.id
}

data "archive_file" "hello_world" {
  type        = "zip"
  source_file = "${path.module}/hello_world.py"
  output_path = "${path.module}/hello_world.zip"
}

locals {
  publish_code_command = "az webapp deployment source config-zip --resource-group ${data.azurerm_resource_group.rg2.name} --name ${azurerm_function_app.azure_functionapp1.name} --src ${data.archive_file.hello_world.output_path}"
}

resource "null_resource" "functionapp_publish" {
  provisioner "local-exec" {
    command = local.publish_code_command
  }
  depends_on = [local.publish_code_command]
}
output "function_app_default_hostname" {
  value = azurerm_function_app.azure_functionapp1.default_hostname
}
resource "azurerm_log_analytics_workspace" "log_space_1" {
  name                = var.log_space_name
  location            = data.azurerm_resource_group.rg2.location
  resource_group_name = data.azurerm_resource_group.rg2.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_cosmosdb_account" "cosmosdb_1" {
  name                = var.cosmosdb-name
  location            = data.azurerm_resource_group.rg2.location
  resource_group_name = data.azurerm_resource_group.rg2.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  geo_location {
    location          = data.azurerm_resource_group.rg2.location
    failover_priority = 1
  }

  geo_location {
    location          = "centralus"
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "sql_database1" {
  name                = var.sql_database_name
  resource_group_name = azurerm_cosmosdb_account.cosmosdb_1.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb_1.name
  throughput          = 400
}
#create cosmosDB account and SQL database account