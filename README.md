# Event Hubs

Deploys an Event Hub Namespace with a list of event hubs connected to it. Each Event Hub can have a set of consumer groups and keys (authorization rules). Its recommended to create one consumer group per application / system that should process events.

It is not possible to create any hub key that have access to manage the hub. Management will be done with terraform templates and therefore not added as an input variable.

## Usage

Example showing deployment of a namespace with single hub.

```terraform
module "simple" {
    source = "../../"

    name = "simple"
    location = "westeurope"
    resource_group_name = "events-simple-rg"
    sku = "Standard"

    hubs = [
        {
            name = "input"
            partitions = 8
            message_retention = 1
            consumers = [
                "app1",
                "app2"
            ]
            keys = [
                {
                    name = "app1"
                    listen = true
                    send = false
                },
                {
                    name = "app2"
                    listen = true
                    send = true
                }
            ]
        }
    ]
}
```

Output from module is the namespace_id, map of hubs and their id and a map of hubs and primary and secondary key for each entry in keys list.

For this simple example output would look like this:

```terraform
namespace_id = /subscriptions/{subscriptionId}/resourceGroups/events-simple-rg/providers/Microsoft.EventHub/namespaces/simple-ns

hub_ids = {
    "input" = "/subscriptions/{subscriptionId}/resourceGroups/events-simple-rg/providers/Microsoft.EventHub/namespaces/simple-ns/eventhubs/input"
}

keys = {
    "app1" = {
        "primary_key" = "DWEIB4wIpTd8obDP05CPGS8TjtQxCZmesONwW6LrOB4="
        "secondary_key" = "..."
    }
    "app2" = {
        "primary_key" = "...="
        "secondary_key" = "..."
    }
}
```