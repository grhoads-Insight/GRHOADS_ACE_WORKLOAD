variable "env" {
    description = "environment declaration"
    default = "dev"
    #add a default? maybe change for each branch?
}
variable "app_service_plan_name" {
    description = "name for app service plan for workload"
    default = "app-service-plan-${var.env}"
}

variable "web_app_name" {
    description = "name for main web app"
    default = "web-app-"
}

variable "function_app_name" {
    description = "name for function app"
    default = "function-app-${var.env}"
}

variable "log_space_name" {
    description = "name for log analytics workspace"
    default = "log-space-${var.env}"
}

variable "cosmosDB-name" {
    description = "name for cosmosDB account"
    default = "workload-cosmosdb-${var.env}"
}

variable "sql_database_name" {
    description = "name for sql database"
    default = "workload-sqldatabase-${var.env}"
}