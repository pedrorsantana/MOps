resource "azurerm_virtual_machine" "azmain" {
  count = var.azure ? 1 : 0

  name = "tst"
  location = data.terraform_remote_state.network.outputs.common_location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name

  network_interface_ids = data.terraform_remote_state.network.outputs.network_interface_ids

  vm_size = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_data_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
