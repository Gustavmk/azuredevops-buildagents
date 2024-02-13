data "azuredevops_project" "main" {
  name = var.project_name
}

resource "azuredevops_variable_group" "example" {
  project_id   = data.azuredevops_project.main.id
  name         = "Azure DevOps Build Agents"
  description  = "Variable group for creating AzureDevOps self-hosted build agents"
  allow_access = true

  variable {
    name         = "AZURE_AGENTS_RESOURCE_GROUP"
    secret_value = var.AZURE_AGENTS_RESOURCE_GROUP
    is_secret    = false
  }

  variable {
    name         = "AZURE_LOCATION"
    secret_value = var.AZURE_LOCATION
    is_secret    = false
  }

  variable {
    name         = "AZURE_RESOURCE_GROUP"
    secret_value = var.AZURE_RESOURCE_GROUP
    is_secret    = false
  }

  variable {
    name         = "AZURE_SUBSCRIPTION"
    secret_value = var.AZURE_SUBSCRIPTION
    is_secret    = false
  }

  variable {
    name         = "BUILD_AGENT_VNET_NAME"
    secret_value = var.BUILD_AGENT_VNET_NAME
    is_secret    = false
  }

  variable {
    name         = "BUILD_AGENT_VNET_RESOURCE_GROUP"
    secret_value = var.BUILD_AGENT_VNET_RESOURCE_GROUP // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "BUILD_AGENT_SUBNET_NAME"
    secret_value = var.BUILD_AGENT_SUBNET_NAME // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "AZURE_TENANT"
    secret_value = var.AZURE_TENANT // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "CLIENT_ID"
    secret_value = var.CLIENT_ID // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "CLIENT_SECRET"
    secret_value = var.CLIENT_SECRET // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "RUN_VALIDATION_FLAG"
    secret_value = var.RUN_VALIDATION_FLAG // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "GALLERY_NAME"
    secret_value = var.GALLERY_NAME // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "GALLERY_RESOURCE_GROUP"
    secret_value = var.GALLERY_RESOURCE_GROUP // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "VMSS_Windows2019"
    secret_value = var.VMSS_Windows2019 // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "VMSS_Windows2022"
    secret_value = var.VMSS_Windows2022 // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "VMSS_Ubuntu2004"
    secret_value = var.VMSS_Ubuntu2004 // This is where you would put your secret value if applicable
    is_secret    = false
  }

  variable {
    name         = "VMSS_Ubuntu2204"
    secret_value = var.VMSS_Ubuntu2204 // This is where you would put your secret value if applicable
    is_secret    = false
  }

}

