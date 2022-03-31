
terraform {
  backend "azurerm" {
    resource_group_name   = "__TF_Backend_RG__"
    storage_account_name  = "__TF_Backend_StorageAcc_Name__"
    container_name        = "__TF_Backend_Container_Name__"
    key                   = "__TF_State_Path_Key__"
    access_key = "__TF_Backend_StorageAcc_Key__"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "linux_vm" {
    name     = var.resourceGroup_name
    location = var.resource_location

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "linux_vm_vnet" {
    name                = "linux-vm-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.linux_vm.location
    resource_group_name = azurerm_resource_group.linux_vm.name

    tags = {
        environment = "Terraform Demo"
    }
}

# Create subnet
resource "azurerm_subnet" "linux_vm_subnet" {
    name                 = "default"
    resource_group_name  = azurerm_resource_group.linux_vm.name
    virtual_network_name = azurerm_virtual_network.linux_vm_vnet.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "linux_vm_publicip" {
    name                         = "linuxVM-pip"
    location                     = azurerm_resource_group.linux_vm.location
    resource_group_name          = azurerm_resource_group.linux_vm.name
    allocation_method            = "Static"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "linux_vm_nsg" {
    name                = "linux-vm-nsg"
    location            = azurerm_resource_group.linux_vm.location
    resource_group_name = azurerm_resource_group.linux_vm.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "linux_vm_nic" {
    name                      = "linux-vm-nic"
    location                  = azurerm_resource_group.linux_vm.location
    resource_group_name       = azurerm_resource_group.linux_vm.name

    ip_configuration {
        name                          = "ipConfig1"
        subnet_id                     = azurerm_subnet.linux_vm_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.linux_vm_publicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "linux_vm_nic_nsg" {
    network_interface_id      = azurerm_network_interface.linux_vm_nic.id
    network_security_group_id = azurerm_network_security_group.linux_vm_nsg.id
}



# # Create (and display) an SSH key
# resource "tls_private_key" "example_ssh" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }
# output "tls_private_key" { value = "${tls_private_key.example_ssh.private_key_pem}" }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "linux_vm" {
    name                  = var.virtual_machine_name
    location              = azurerm_resource_group.linux_vm.location
    resource_group_name   = azurerm_resource_group.linux_vm.name
    network_interface_ids = [azurerm_network_interface.linux_vm_nic.id]
    size                  = var.virtualMachine_size

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "StandardSSD_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "LinuxVM"
    admin_username = "zohair"
    admin_password = "Azurevm@12101994"
    disable_password_authentication = false
        
    # admin_ssh_key {
    #     username       = "azureuser"
    #     public_key     = tls_private_key.example_ssh.public_key_openssh
    # }


    tags = {
        environment = "Terraform Demo"
    }

    
}

output "linux_vm_ip_address" {
  description = "Virtual Machine name IP Address"
  value       =  azurerm_public_ip.linux_vm_publicip.ip_address
}