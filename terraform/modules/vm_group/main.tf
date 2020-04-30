resource "digitalocean_droplet" "droplet" {
  count = length(var.vms)

  image = var.vms[count.index].image
  name = replace(var.vms[count.index].name, " ", "-")
  size = var.vms[count.index].size
  backups = var.vms[count.index].backups

  ssh_keys = [var.master_key_id]

  tags = concat(var.vms[count.index].tags, [
    "timestamp:${timestamp()}",
    "image:${var.vms[count.index].image}",
    "size:${var.vms[count.index].size}",
  ])

  region = "ams3"
  ipv6 = true
  monitoring = true
  resize_disk = true
}
