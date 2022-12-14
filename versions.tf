terraform {

  cloud {
    organization = "insight"

    workspaces {
      name = "grhoads-ace-workload"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.20.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "null" {

}

provider "archive" {

}