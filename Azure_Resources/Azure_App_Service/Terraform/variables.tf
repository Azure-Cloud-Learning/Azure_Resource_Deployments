variable "asp_name" {
  type = string
  description = "App service plan name"
}

variable "resourceGroup" {
  type = string
  description = "Resource group name"
}

variable "location" {
  type = string
  description = "Location of resources."
  default = "eastus"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "asp_kind" {
  type = string
  default = "Linux"
}

variable "asp_reserved" {
  type = bool
  default = "true"
}

variable "asp_sku" {
  type = object({
   tier = string
   size = string
   capacity = number
  })
  description = "SKU of App service plan"
  default = {
    capacity = 1
    size = "F1"
    tier = "Free"
  }
  
  validation {
    condition = (var.asp_sku.size == "F1" || var.asp_sku.size == "S1")
    error_message = "Allowed values for asp_sku are F1 & S1."
  }
}

variable "app_name" {
  type = string
  description = "App service name"
}