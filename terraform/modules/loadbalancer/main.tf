resource "azurerm_public_ip" "lb_ip" {
  name                = "${var.humber_id}-lb-pip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "lb" {
  name                = "${var.humber_id}-lb"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "${var.humber_id}-backend"
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "${var.humber_id}-http-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_rule" "rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "${var.humber_id}-http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids      = [azurerm_lb_backend_address_pool.backend.id]
  probe_id                       = azurerm_lb_probe.probe.id
}

# Temporarily commented out to bypass Invalid count argument error
#resource "azurerm_network_interface_backend_address_pool_association" "nic_pool" {
 # count                   = length(var.vm_nic_ids)
  #network_interface_id    = var.vm_nic_ids[count.index]
  #ip_configuration_name   = "internal"
  #backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id
  #depends_on              = [var.vm_nic_ids]
#}

output "lb_fqdn" {
  value = azurerm_public_ip.lb_ip.fqdn
}
