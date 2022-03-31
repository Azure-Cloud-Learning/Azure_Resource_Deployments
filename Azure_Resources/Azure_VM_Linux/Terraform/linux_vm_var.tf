variable "virtual_machine_name" {
    type = string
    description = "Name of virtual machine."
}

variable "virtualMachine_size" {
    type = string
    description = "Virtual machine size"
    default = "Standard_B2s"
}

variable "resourceGroup_name" {
    type = string
    description = "Virtual machine size"
    default = "linux-vm-rg"
}

variable "resource_location" {
    type = string
    description = "Virtual machine size"
    default = "southeastasia"
}