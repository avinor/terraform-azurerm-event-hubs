# Event Hubs

Deploys an Event Hub Namespace with a list of event hubs connected to it. Each Event Hub can have a set of consumer groups and keys (authorization rules). Its recommended to create one consumer group per application / system that should process events.

It is not possible to create any hub key that have access to manage the hub. Management will be done with terraform templates and therefore not added as an input variable.

## Usage

Example showing deployment of a namespace with single hub using [tau](https://github.com/avinor/tau)

```terraform
module {
    source = "avinor/event-hubs/azurerm"
    version = "1.1.0"

inputs {
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

## Diagnostics

Diagnostics settings can be sent to either storage account, event hub or Log Analytics workspace. The variable `diagnostics.destination` is the id of receiver, ie. storage account id, event namespace authorization rule id or log analytics resource id. Depending on what id is it will detect where to send. Unless using event namespace the `eventhub_name` is not required, just set to `null` for storage account and log analytics workspace.

Setting `all` in logs and metrics will send all possible diagnostics to destination. If not using `all` type name of categories to send.

## NIST compliance

High level checklist of compliance against NIST Cybersecurity Framework.

**PR.AC-4**: Access permissions are managed, incorporating the principles of least privilege and separation of duties

Assign least privilege possible when creating access keys. Only assign required privileges.

**PR.AC-5**: Network integrity is protected, incorporating network segregation where appropriate

Use `network_rules` to protect the namespace from unwanted access where possible. Bind to subnet where services consuming / producing data is located and restrict by ip if access is required outside Azure.

**PR.DS-1**: Data-at-rest is protected

<https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-security-controls>

**PR.DS-2**: Data-in-transit is protected

See above. Only encrypted channels supported.

AMQPs: <https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-amqp-protocol-guide#basic-amqp-scenarios>  
Kafka: <https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview#security-and-authentication>

**PR.IP-4**: Backups of information are conducted, maintained, and tested periodically

Not using Capture as data are considered only valuable in short periods and not performing any backup of data.

**DE.CM-7**: Monitoring for unauthorized personnel, connections, devices, and software is performed

Use diagnostic settings to forward all logs for analysis.
