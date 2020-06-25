# Since we"re using digitalocean, our provider will be digitalocean
provider "digitalocean" {
  token = var.do_token
}

# This is the master public key that will be used to to provision everything with ansible
module "master_key" {
  name       = "Master Key"
  public_key = var.master_key
  source     = "./modules/do_key"
}

# The digital ocean project that will be used to house Docent vms
module "docent_project" {
  name        = "TF-Docenten"
  description = "Alle VMs voor docent aangevraagd via Terraform. Gebruik Terraform om wijzigingen aan te brengen!"
  environment = "Production"
  # Place all docent vms and the domain into this project
  resources = concat(
    values(module.docent_vms).*.urn,
    [
      # This object contains all our state
      "do:space:avans-terraform-state",
      digitalocean_domain.domain.urn
    ]
  )
  source = "./modules/do_project"
}

# The digital ocean project that will be used to house Student vms
module "student_project" {
  name        = "TF-Studenten"
  description = "Alle VMs voor studenten aangevraagd via Terraform. Gebruik Terraform om wijzigingen aan te brengen!"
  environment = "Production"
  # Place all student vms into this project
  resources = values(module.student_vms).*.urn
  source    = "./modules/do_project"
}

# Our domain
resource "digitalocean_domain" "domain" {
  name = var.domain
}

# Records to connect the domain to student vms
resource "digitalocean_record" "student_subdomains" {
  for_each = var.student_vms
  domain   = digitalocean_domain.domain.name
  name     = "${each.key}.student"
  type     = "A"
  ttl      = 32
  value    = module.student_vms[each.key].ipv4
}

# Records to connect the domain to docent vms
resource "digitalocean_record" "docent_subdomains" {
  for_each = var.docent_vms
  domain   = digitalocean_domain.domain.name
  name     = each.value.subdomain
  type     = "A"
  ttl      = 32
  value    = module.docent_vms[each.key].ipv4
}

# Module that handles all the student vms
module "student_vms" {
  source   = "./modules/do_vm"
  for_each = var.student_vms

  image    = each.value.image
  name     = "${replace(each.key, " ", "-")}.student"
  size     = each.value.size
  backups  = each.value.backups
  ssh_keys = [module.master_key.id]
  tags = [
    "student:${each.key}"
  ]
}

# Module that handles all the docent vms
module "docent_vms" {
  source   = "./modules/do_vm"
  for_each = var.docent_vms

  image    = each.value.image
  name     = replace(each.key, " ", "-")
  size     = each.value.size
  backups  = each.value.backups
  ssh_keys = [module.master_key.id]
  tags = [
    "docent:${replace(each.value.docent_name, " ", "")}"
  ]
}
