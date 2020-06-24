output "ipv4" {
  value = digitalocean_droplet.droplet.ipv4_address
}

output "urn" {
  value = digitalocean_droplet.droplet.urn
}

output "name" {
  value = digitalocean_droplet.droplet.name
}
