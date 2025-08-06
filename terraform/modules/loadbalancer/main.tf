resource "azurerm_public_ip" "lb_ip" {
  name                = "6553-lb-pip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
resource "azurerm_lb" "lb" {
  name                = "6553-lb"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
  tags = var.tags
}
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "6553-backend"
}
resource "azurerm_network_interface_backend_address_pool_association" "nic_pool" {
  count                   = length(var.vm_nic_ids)
  network_interface_id    = var.vm_nic_ids[count.index]
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  depends_on              = [var.vm_nic_ids]
}
resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "6553-http-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}
resource "azurerm_lb_rule" "rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "6553-http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.probe.id
}
