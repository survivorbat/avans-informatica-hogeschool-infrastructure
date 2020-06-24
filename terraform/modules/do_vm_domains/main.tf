resource "digitalocean_domain" "domain" {
  name = var.domain
}

data "digitalocean_droplet" "droplet" {
  name  = var.do_vm_names[count.index]
  count = length(var.do_vm_names)
  depends_on = [var.do_vm_names]
}

resource "digitalocean_record" "record_a" {
  count  = length(var.do_vm_names)
  domain = digitalocean_domain.domain.name
  name   = var.do_vm_names[count.index]
  type   = "A"
  value  = data.digitalocean_droplet.droplet[count.index].ipv4_address
}

resource "digitalocean_record" "record_aaaa" {
  count  = length(var.do_vm_names)
  domain = digitalocean_domain.domain.name
  name   = var.do_vm_names[count.index]
  type   = "AAAA"
  value  = data.digitalocean_droplet.droplet[count.index].ipv6_address
}
