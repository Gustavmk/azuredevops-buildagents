terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}


resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = var.tags
}

resource "azurerm_shared_image_gallery" "main" {
  name                = var.shared_image_gallery_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  description         = "Shared images and things."

  tags = var.tags
}

module "ubuntu2004-agentpool-full" {
  source                  = "./modules/shared-image"
  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name
  gallery_name            = var.shared_image_gallery_name

  identifier_publisher = var.identifier_publisher
  identifier_offer     = "DevOps"
  identifier_sku       = "ubuntu2004"
  image_definition     = "ubuntu2004-agentpool-full"
  os_type              = "Linux"

  depends_on = [azurerm_shared_image_gallery.main]
}

module "ubuntu2204-agentpool-full" {
  source                  = "./modules/shared-image"
  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name
  gallery_name            = var.shared_image_gallery_name

  identifier_publisher = var.identifier_publisher
  identifier_offer     = "DevOps"
  identifier_sku       = "ubuntu2204"
  image_definition     = "ubuntu2204-agentpool-full"
  os_type              = "Linux"

  depends_on = [azurerm_shared_image_gallery.main]
}

module "windows2019-agentpool-full" {
  source                  = "./modules/shared-image"
  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name
  gallery_name            = var.shared_image_gallery_name

  identifier_publisher = var.identifier_publisher
  identifier_offer     = "DevOps"
  identifier_sku       = "windows2019"
  image_definition     = "windows2019-agentpool-full"
  os_type              = "Windows"

  depends_on = [azurerm_shared_image_gallery.main]
}

module "windows2022-agentpool-full" {
  source                  = "./modules/shared-image"
  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name
  gallery_name            = var.shared_image_gallery_name

  identifier_publisher = var.identifier_publisher
  identifier_offer     = "DevOps"
  identifier_sku       = "windows2022"
  image_definition     = "windows2022-agentpool-full"
  os_type              = "Windows"

  depends_on = [azurerm_shared_image_gallery.main]
}

resource "azurerm_resource_group" "packer_build" {
  name     = "rg-temp-packer"
  location = var.resource_group_location

  tags = var.tags
}


module "variable_group" {
  source       = "./modules/variable_group"
  project_name = "DryLabs"

  # shared Gallery 
  GALLERY_NAME           = var.shared_image_gallery_name
  GALLERY_RESOURCE_GROUP = var.resource_group_name

  AZURE_LOCATION       = azurerm_resource_group.packer_build.name // Azure location where Packer will create the temporary resources
  AZURE_RESOURCE_GROUP = var.resource_group_name                  // Resource group that will be used by Packer to put the resulting Azure Managed Image.

  # Azure Authentication 
  AZURE_SUBSCRIPTION = ""
  AZURE_TENANT       = ""
  CLIENT_ID          = ""
  CLIENT_SECRET      = ""

  # Azure DevOps Specs After Build Images
  AZURE_AGENTS_RESOURCE_GROUP = "" // Resource Group that contains the Virtual Machine Scale Sets to be used as Scale Set Agents in Azure DevOps
  VMSS_Windows2019            = "win2019"
  VMSS_Windows2022            = "win2022"
  VMSS_Ubuntu2004             = "ubuntu2004"
  VMSS_Ubuntu2204             = "ubuntu2204"

  depends_on = [
    azurerm_resource_group.packer_build
  ]

}