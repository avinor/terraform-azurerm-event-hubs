variables {
  name                = "simple"
  location            = "westeurope"
  resource_group_name = "events-simple-rg"
  sku                 = "Standard"
  capacity            = 1
}

run "with-hubs" {
  command = plan
}