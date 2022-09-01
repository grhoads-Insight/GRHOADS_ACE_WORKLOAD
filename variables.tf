variable "env" {
  description = "environment declaration"
  default     = "dev"
  #add a default? maybe change for each branch?
}
variable "webapp_service_plan_name" {
  description = "name for app service plan for workload"
  default     = "webapp-service-plan"
}

variable "functionapp_service_plan_name" {
  description = "name for app service plan for workload"
  default     = "functionapp-service-plan"
}

variable "web_app_name" {
  description = "name for main web app"
  default     = "grhoads-web-app"
}

variable "function_app_name" {
  description = "name for function app"
  default     = "grhoads-function-app"
}

variable "log_space_name" {
  description = "name for log analytics workspace"
  default     = "log-space"
}

variable "cosmosdb-name" {
  description = "name for cosmosDB account"
  default     = "workload-cosmosdb"
}

variable "sql_database_name" {
  description = "name for sql database"
  default     = "workload-sqldatabase"
}

variable "sql_server_name" {
  description = "name for sql database"
  default     = "workload-sqlserver"
}