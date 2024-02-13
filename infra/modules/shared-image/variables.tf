variable "image_definition" {}
variable "gallery_name" {}
variable "resource_group_name" {}
variable "resource_group_location" {}
variable "os_type" {
  description = "Linux or Windows"
  type        = string
}
variable "identifier_publisher" {}
variable "identifier_offer" {}
variable "identifier_sku" {}