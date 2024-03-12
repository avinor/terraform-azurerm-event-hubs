variables {
  name                = "simple"
  location            = "westeurope"
  resource_group_name = "events-simple-rg"
  sku                 = "Standard"
  capacity            = 1

  hubs = [
    {
      name              = "input"
      partitions        = 8
      message_retention = 1
      consumers = [
        "app1",
        "app2"
      ]
      keys = [
        {
          name   = "app1"
          listen = true
          send   = false
        },
        {
          name   = "app2"
          listen = true
          send   = true
        }
      ]
    }
  ]
}

run "with-hubs" {
  command = plan
}