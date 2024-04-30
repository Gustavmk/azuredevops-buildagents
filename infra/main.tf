terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
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

resource "azurerm_resource_group" "packer_build" {
  name     = "rg-temp-packer2024"
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
  for_each = var.images

  source                  = "./modules/shared-image"
  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name
  gallery_name            = var.shared_image_gallery_name

  identifier_publisher = each.value["publisher"]
  identifier_offer     = each.value["offer"]
  identifier_sku       = each.value["sku"]
  image_definition     = each.value["definition"]
  os_type              = each.value["osType"]

  depends_on = [azurerm_shared_image_gallery.main]
}


module "vm_azure_pipeline_first_agent" {
  source         = "./modules/vm_azure_pipeline_first_agent"
  location       = azurerm_resource_group.main.location
  vm_os_simple   = "UbuntuServer"
  public_ip_dns  = ["linsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id = module.vnet.vnet_subnets[0]
  
  tags = {
    Environment = "test"
  }
}

module "vnet" {
  source              = "./modules/vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}