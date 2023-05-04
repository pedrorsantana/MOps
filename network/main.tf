resource "azurerm_resource_group" "azmain" {
    count = var.azure ?  1 : 0
    name = "testpath"
    location = "West Europe"
}

resource "azurerm_network_security_group" "azmain" {
    count = var.azure ? 1 : 0
    name = format("%s_%s", azurerm_resource_group.azmain.0.name, "sg")
    location = azurerm_resource_group.azmain.0.location
    resource_group_name = azurerm_resource_group.azmain.0.name

    security_rule {
        name = "test"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_virtual_network" "azmain" {
    count = var.azure ? 1 : 0
    
    name = format("%s_%s",azurerm_resource_group.azmain.0.name,"virtualnetwork")
    location = azurerm_resource_group.azmain.0.location
    resource_group_name = azurerm_resource_group.azmain.0.name

    address_space = [ "10.0.0.0/16" ]
    
    subnet {
        name = format("%s_%s_%s",azurerm_resource_group.azmain.0.name,"subnet","A")
        address_prefix = "10.0.1.0/24"
    }

    subnet {
        name = format("%s_%s_%s",azurerm_resource_group.azmain.0.name,"subnet","B")
        address_prefix = "10.0.2.0/24"
        security_group = azurerm_network_security_group.azmain.0.id
    }
}

resource "azurerm_network_interface" "azmain" {
  count = var.azure ? 1 : 0

  name = format("%s_%s", azurerm_resource_group.azmain.0.name, "nwinterface")
  location = azurerm_resource_group.azmain.0.location
  resource_group_name = azurerm_resource_group.azmain.0.location

  ip_configuration {
    name = "internalnw"
    subnet_id = "/subscriptions/209824ac-c832-47e8-bd40-e8e09c05e436/resourceGroups/trial-kube-hardway/providers/Microsoft.Network/virtualNetworks/vpc-kubehardway/subnets/default"

    private_ip_address_allocation = "Dynamic"
  }
}