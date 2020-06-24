resource "digitalocean_ssh_key" "ssh_key" {
  name       = var.name
  public_key = var.public_key
}
