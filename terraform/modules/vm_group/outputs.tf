locals {
  droplet_data = [
    for droplet in digitalocean_droplet.droplet.* : {
        ipv4 = droplet.ipv4_address,
        ipv6 = droplet.ipv6_address,
        name = droplet.name
    }
  ]
}

output "droplet_data" {
  value = local.droplet_data
}

output "droplet_urns" {
  value = digitalocean_droplet.droplet.*.urn
}
