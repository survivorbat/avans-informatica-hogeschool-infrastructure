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
      module.domain.domain_urn
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
  source = "./modules/do_project"
}

# The main domain used to house all the project under
module "domain" {
  # Existing domain
  domain = var.domain

  # Get names to all the droplets
  do_vm_names = concat(
      values(module.docent_vms).*.name,
      values(module.student_vms).*.name
  )
  depends_on = [module.student_vms.*]
  source  = "./modules/do_vm_domains"
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
  tags     = [
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
  tags     = [
    "docent:${replace(each.value.docent_name, " ", "")}"
  ]
}
