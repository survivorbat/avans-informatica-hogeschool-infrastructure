resource "digitalocean_droplet" "droplet" {
  image   = var.image
  name    = var.name
  size    = var.size
  backups = var.backups

  ssh_keys = var.ssh_keys

  tags = concat(var.tags, [
    "timestamp:${timestamp()}",
    "image:${var.image}",
    "size:${var.size}"
  ])

  region      = "ams3"
  ipv6        = true
  monitoring  = true
  resize_disk = true
}
