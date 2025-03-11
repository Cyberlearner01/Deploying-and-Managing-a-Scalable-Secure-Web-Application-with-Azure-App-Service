provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "project-1" {
  name     = "Project-rg"
  location = "Canada Central"
}

resource "azurerm_service_plan" "app_plan" {
  name                = "Johnson-plan"
  location            = azurerm_resource_group.project-1.location
  resource_group_name = azurerm_resource_group.project-1.name
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
  app_id                 = azurerm_linux_web_app.webapp.id
  repo_url               = "https://github.com/Cyberlearner01/Deploying-and-Managing-a-Scalable-Secure-Web-Application-with-Azure-App-Service.git"
  branch                 = "main"
  use_manual_integration = false
}
