# Jumpbox VM
resource "azurerm_public_ip" "jumpbox_vm_pip" {
  name                = "${var.prefix}${var.name}-jumpbox-vm-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "jumpbox_vm_nic" {
  name                = "${var.prefix}${var.name}-jumpbox-vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_vm_pip.id
  }
}

data "http" "local_external_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "jumpbox_nsg" {
  name                = "${var.prefix}${var.name}-jumpbox-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = tolist(setunion(var.jumpbox_ssh_source_address_prefixes, ["${chomp(data.http.local_external_ip.body)}/32"]))
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "jumpbox_nsg_association" {
  network_interface_id      = azurerm_network_interface.jumpbox_vm_nic.id
  network_security_group_id = azurerm_network_security_group.jumpbox_nsg.id
}

resource "tls_private_key" "jumpbox_vm_ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_linux_virtual_machine" "jumpbox_vm" {
  name                            = "${var.prefix}${var.name}-jumpbox-vm"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = "Standard_D2_v2"
  admin_username                  = "eudcc"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "eudcc"
    public_key = chomp(tls_private_key.jumpbox_vm_ssh.public_key_openssh)
  }

  custom_data = filebase64("${path.module}/scripts/jumpbox-bootstrap.sh")

  network_interface_ids = [
    azurerm_network_interface.jumpbox_vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_virtual_machine_extension" "jumpbox_vm_aad" {
  name                       = "${var.prefix}${var.name}-jumpbox-vm-aad"
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  virtual_machine_id         = azurerm_linux_virtual_machine.jumpbox_vm.id
}

resource "azurerm_role_assignment" "jumpbox_vm_aad_admins" {
  scope                = azurerm_linux_virtual_machine.jumpbox_vm.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = var.administrator_group_oid
}

resource "azurerm_role_assignment" "jumpbox_vm_aad_users" {
  scope                = azurerm_linux_virtual_machine.jumpbox_vm.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = var.administrator_group_oid
}
