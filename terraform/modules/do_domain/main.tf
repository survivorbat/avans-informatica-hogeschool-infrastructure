data "digitalocean_domain" "domain" {
  name = var.domain
}

resource "digitalocean_record" "record" {
  count = length(var.records)
  domain = data.digitalocean_domain.domain.name
  name = var.records[count.index].name
  type = var.records[count.index].type
  value = var.records[count.index].value
}
