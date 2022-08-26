variable "app_service_plan_name" {
    description = "name for app service plan for workload"
    default = "app-service-plan-main"
}

variable "web_app_name" {
    description = "name for main web app"
    default = "web-app-main"
}

variable "function_app_name" {
    description = "name for function app"
    default = "function-app-main"
}