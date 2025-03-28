terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "mailchimp-etl-rg"
  location = "East US"  # Adjust as needed
}

# 2. Generate a random suffix for unique resource names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# 3. Create an Azure Storage Account for the ETL layers
resource "azurerm_storage_account" "sa" {
  name                     = "mailchimpetl${random_string.suffix.result}"  # Must be globally unique
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true

  tags = {
    environment = "production"
    project     = "MailChimp_ETL"
  }
}

# 4. Create Storage Containers for each ETL layer
resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "gold" {
  name                  = "gold"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

# 5. Provision an Azure Databricks Workspace
resource "azurerm_databricks_workspace" "dbw" {
  name                = "mailchimpETLWorkspace"  # Matches project context
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"

  tags = {
    environment = "testing"
    project     = "MailChimp_ETL"
  }
}

# (Optional) 6. Provision an Azure Key Vault for storing API keys/secrets
resource "azurerm_key_vault" "kv" {
  name                        = "mailchimpETLKV${random_string.suffix.result}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get",
      "list",
      "set",
      "delete"
    ]
  }
}

data "azurerm_client_config" "current" {}

# Outputs for convenience
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  description = "The name of the Azure Storage Account"
  value       = azurerm_storage_account.sa.name
}

output "databricks_workspace_url" {
  description = "The URL of the Azure Databricks Workspace"
  value       = azurerm_databricks_workspace.dbw.workspace_url
}

output "key_vault_name" {
  description = "The name of the Azure Key Vault"
  value       = azurerm_key_vault.kv.name
}
