module "simple" {
  source = "../../"

  name                = "simple"
  location            = "westeurope"
  resource_group_name = "events-simple-rg"
  sku                 = "Standard"
  capacity            = 1
}