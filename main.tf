resource "azurerm_service_plan" "webapp_serviceplan" {
  for_each            = var.env
  name                = "${var.webapp_service_plan_name}-${each.value}"
  resource_group_name = data.azurerm_resource_group.environment_rg["${each.value}"].name
  location            = data.azurerm_resource_group.environment_rg["${each.value}"].location
  os_type             = "Linux"
  sku_name            = "P1v2"

  tags = {
    "Environment"   = "${each.value}"
    "Resource Type" = "Workload"
  }
}

resource "azurerm_service_plan" "functionapp_serviceplan" {
  for_each            = var.env
  name                = "${var.functionapp_service_plan_name}-${each.value}"
  resource_group_name = data.azurerm_resource_group.environment_rg["${each.value}"].name
  location            = data.azurerm_resource_group.environment_rg["${each.value}"].location
  os_type             = "Linux"
  sku_name            = "P1v2"

  tags = {
    "Environment"   = "${each.value}"
    "Resource Type" = "Workload"
  }
}
resource "azurerm_linux_web_app" "web_app1" {
  for_each            = var.env
  name                = "${var.web_app_name}-${each.value}"
  resource_group_name = data.azurerm_resource_group.environment_rg["${each.value}"].name
  location            = data.azurerm_resource_group.environment_rg["${each.value}"].location
  service_plan_id     = azurerm_service_plan.webapp_serviceplan["${each.value}"].id

  site_config {}

  tags = {
    "Environment"   = "${each.value}"
    "Resource Type" = "Workload"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "swift_appservice" {
  for_each       = var.env
  app_service_id = azurerm_linux_web_app.web_app1["${each.value}"].id
  subnet_id      = data.azurerm_subnet.web-subnet["${each.value}"].id
}

resource "azurerm_function_app" "azure_functionapp1" {
  for_each            = var.env
  name                = "${var.function_app_name}-${each.value}"
  resource_group_name = data.azurerm_resource_group.environment_rg["${each.value}"].name
  location            = data.azurerm_resource_group.environment_rg["${each.value}"].location
  app_service_plan_id = azurerm_service_plan.functionapp_serviceplan["${each.value}"].id
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
  storage_account_name       = data.azurerm_storage_account.storage_account1["${each.value}"].name
  storage_account_access_key = data.azurerm_storage_account.storage_account1["${each.value}"].primary_access_key
  version                    = "~3"

  tags = {
    "Environment"   = "${each.value}"
    "Resource Type" = "Workload"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "swift_function" {
  for_each       = var.env
  app_service_id = azurerm_function_app.azure_functionapp1["${each.value}"].id
  subnet_id      = data.azurerm_subnet.app-subnet["${each.value}"].id
}

data "archive_file" "hello_world" {
  type        = "zip"
  source_file = "${path.module}/hello_world.py"
  output_path = "${path.module}/hello_world.zip"
}

#code used to publish data to function app
#only works when running terraform locally

# locals {
#   publish_code_command = "az webapp deployment source config-zip --resource-group ${data.azurerm_resource_group.workload_rg.name} --name ${azurerm_function_app.azure_functionapp1.name} --src ${data.archive_file.hello_world.output_path}"
# }

# resource "null_resource" "functionapp_publish" {
#   provisioner "local-exec" {
#     command = local.publish_code_command
#   }
#   depends_on = [local.publish_code_command]
# }
# output "function_app_default_hostname" {
#   value = azurerm_function_app.azure_functionapp1.default_hostname
# }
resource "azurerm_log_analytics_workspace" "log_space1" {
  for_each            = var.env
  name                = "${var.log_space_name}-${each.value}"
  resource_group_name = data.azurerm_resource_group.environment_rg["${each.value}"].name
  location            = data.azurerm_resource_group.environment_rg["${each.value}"].location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    "Environment"   = "${each.value}"
    "Resource Type" = "Workload"
  }
}

resource "azurerm_cosmosdb_account" "cosmosdb1" {
  for_each                          = var.env
  name                              = "${var.cosmosdb-name}-${each.value}"
  resource_group_name               = data.azurerm_resource_group.environment_rg["${each.value}"].name
  location                          = data.azurerm_resource_group.environment_rg["${each.value}"].location
  offer_type                        = "Standard"
  kind                              = "MongoDB"
  is_virtual_network_filter_enabled = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  geo_location {
    location          = data.azurerm_resource_group.environment_rg["${each.value}"].location
    failover_priority = 1
  }

  geo_location {
    location          = "centralus"
    failover_priority = 0
  }

  virtual_network_rule {
    id                                   = data.azurerm_subnet.data-subnet["${each.value}"].id
    ignore_missing_vnet_service_endpoint = true
  }
  tags = {
    "Environment"   = "${each.value}"
    "Resource Type" = "Workload"
  }
}

resource "azurerm_key_vault_secret" "keyvault_user_secret" {
  for_each     = var.env
  name         = "username-${each.value}"
  value        = "4dm1n157r470r"
  key_vault_id = data.azurerm_key_vault.keyvault1["${each.value}"].id
}

resource "azurerm_key_vault_secret" "keyvault_pass_secret" {
  for_each     = var.env
  name         = "password-${each.value}"
  value        = "4-v3ry-53cr37-p455w0rd"
  key_vault_id = data.azurerm_key_vault.keyvault1["${each.value}"].id
}

resource "azurerm_mssql_server" "mssql_server1" {
  for_each                     = var.env
  name                         = "${var.sql_server_name}-${each.value}"
  resource_group_name          = data.azurerm_resource_group.environment_rg["${each.value}"].name
  location                     = data.azurerm_resource_group.environment_rg["${each.value}"].location
  version                      = "12.0"
  administrator_login          = azurerm_key_vault_secret.keyvault_user_secret["${each.value}"].value
  administrator_login_password = azurerm_key_vault_secret.keyvault_pass_secret["${each.value}"].value

  tags = {
    "Environment"   = "${each.value}"
    "Resource Type" = "Workload"
  }
}

resource "azurerm_mssql_database" "mssql_database1" {
  for_each     = var.env
  name         = "${var.sql_database_name}-${each.value}"
  server_id    = azurerm_mssql_server.mssql_server1["${each.value}"].id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  #would be enabled for prod / premium database
  #read_scale     = true
  #zone_redundant = true

  tags = {
    "Environment"   = "${each.value}"
    "Resource Type" = "Workload"
  }
}