terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.22.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "d07e93af-325f-4672-a73b-124502a553dc"
}

resource "azurerm_resource_group" "project-1" {
  name     = "Project-rg"
  location = "Canada Central"
}

resource "azurerm_service_plan" "app_plan" {
  name                = "Johnson-plan"
  resource_group_name = azurerm_resource_group.project-1.name
  location            = azurerm_resource_group.project-1.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "jaykxr-webapp"
  location            = azurerm_resource_group.project-1.location
  resource_group_name = azurerm_resource_group.project-1.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.github_identity.id]
  }

  site_config {
    always_on = true

    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "18-lts"
    "AZURE_WEBAPP_AUTHENTICATION"  = "identity"
  }
}

resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {
    always_on = true
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "ENVIRONMENT" = "staging"
  }
}

resource "azurerm_user_assigned_identity" "github_identity" {
  name                = "github-identity"
  resource_group_name = azurerm_resource_group.project-1.name
  location            = azurerm_resource_group.project-1.location
}

resource "azurerm_role_assignment" "github_identity_role" {
  scope                = azurerm_linux_web_app.webapp.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github_identity.principal_id
}

resource "azurerm_app_service_source_control" "webapp_source_control" {
  app_id   = azurerm_linux_web_app.webapp.id
  repo_url = "https://github.com/Cyberlearner01/Deploying-and-Managing-a-Scalable-Secure-Web-Application-with-Azure-App-Service"

  branch                 = "main"
  use_manual_integration = false
}

resource "azurerm_app_service_custom_hostname_binding" "custom_domain" {
  hostname            = "www.durojohnson.com"
  app_service_name    = azurerm_linux_web_app.webapp.name
  resource_group_name = azurerm_resource_group.project-1.name
}

resource "azurerm_app_service_certificate_binding" "ssl_binding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.custom_domain.id
  certificate_id      = "/subscriptions/d07e93af-325f-4672-a73b-124502a553dc/resourceGroups/Project-rg/providers/Microsoft.Web/certificates/www.durojohnson.com-jaykxr-webapp"
  ssl_state           = "SniEnabled"
}

resource "azurerm_monitor_autoscale_setting" "webscale-rg" {
  enabled             = true
  location            = "canadacentral"
  name                = "Mywebscaling"
  resource_group_name = azurerm_resource_group.project-1.name
  target_resource_id  = azurerm_service_plan.app_plan.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      maximum = 10
      minimum = 1
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_namespace   = "microsoft.web/serverfarms"
        metric_resource_id = azurerm_service_plan.app_plan.id
        operator           = "GreaterThan"
        statistic          = "Average"
        threshold          = 75
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }

      scale_action {
        cooldown  = "PT5M"
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_namespace   = "Microsoft.Web/serverfarms"
        metric_resource_id = azurerm_service_plan.app_plan.id
        operator           = "LessThan"
        statistic          = "Average"
        threshold          = 25
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }

      scale_action {
        cooldown  = "PT5M"
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
      }
    }
  }
}

resource "azurerm_storage_account" "jaykxrstore" {
  name                     = "jaykxrstore"
  resource_group_name      = azurerm_resource_group.project-1.name
  location                 = azurerm_resource_group.project-1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_workspace" "webapp_log_analytics" {
  name                = "webapp-log-analytics"
  resource_group_name = azurerm_resource_group.project-1.name
  location            = azurerm_resource_group.project-1.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "webapp_insights" {
  name                = "webapp-insights"
  location            = azurerm_resource_group.project-1.location
  resource_group_name = azurerm_resource_group.project-1.name
  application_type    = "web"
}

resource "azurerm_recovery_services_vault" "webapp_backup_vault" {
  name                = "webapp-backup-vault"
  resource_group_name = azurerm_resource_group.project-1.name
  location            = azurerm_resource_group.project-1.location
  sku                 = "Standard"
  }

resource "azurerm_backup_policy_vm" "daily_backup_policy" {
  name                = "daily-backup-policy"
  resource_group_name = azurerm_resource_group.project-1.name
  recovery_vault_name = azurerm_recovery_services_vault.webapp_backup_vault.name

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }
}
