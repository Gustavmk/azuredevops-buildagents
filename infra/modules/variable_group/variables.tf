variable "project_name" {}
variable "AZURE_AGENTS_RESOURCE_GROUP" {}
variable "AZURE_LOCATION" {}
variable "AZURE_RESOURCE_GROUP" {}
variable "AZURE_SUBSCRIPTION" {}
variable "BUILD_AGENT_VNET_NAME" {
  type    = string
  default = null
}
variable "BUILD_AGENT_VNET_RESOURCE_GROUP" {
  type    = string
  default = null
}
variable "BUILD_AGENT_SUBNET_NAME" {
  type    = string
  default = null
}
variable "AZURE_TENANT" {}
variable "CLIENT_ID" {}
variable "CLIENT_SECRET" {}
variable "RUN_VALIDATION_FLAG" {
  default = false
  type    = bool
}
variable "GALLERY_NAME" {}
variable "GALLERY_RESOURCE_GROUP" {}
variable "VMSS_Windows2019" {}
variable "VMSS_Windows2022" {}
variable "VMSS_Ubuntu2004" {}
variable "VMSS_Ubuntu2204" {}