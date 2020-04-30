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
  resources = concat([module.domain.domain_urn], module.docent_vms.droplet_urns)
  source    = "./modules/do_project"
}

# The digital ocean project that will be used to house Student vms
module "student_project" {
  name        = "TF-Studenten"
  description = "Alle VMs voor studenten aangevraagd via Terraform. Gebruik Terraform om wijzigingen aan te brengen!"
  environment = "Production"
  # Place all student vms into this project
  resources = module.student_vms.droplet_urns
  source    = "./modules/do_project"
}

locals {
  # Compile A student records
  a_student_records = [
    for item in module.student_vms.droplet_data : {
      name  = "${item.name}.student"
      type  = "A"
      value = item.ipv4
    }
  ]

  # Compile AAAA student records
  aaaa_student_records = [
    for item in module.student_vms.droplet_data : {
      name  = "${item.name}.student"
      type  = "AAAA"
      value = item.ipv6
    }
  ]

  # Compile A docent records
  a_docent_records = [
    for item in module.docent_vms.droplet_data : {
      name  = var.docent_vms[index(module.docent_vms.droplet_data, item)].subdomain
      type  = "A"
      value = item.ipv4
    }
  ]

  # Compile AAAA docent records
  aaaa_docent_records = [
    for item in module.docent_vms.droplet_data : {
      name  = var.docent_vms[index(module.docent_vms.droplet_data, item)].subdomain
      type  = "AAAA"
      value = item.ipv6
    }
  ]
}

# The main domain used to house all the project under
module "domain" {
  # Existing domain
  domain  = var.domain

  # Compile all wanted records
  records = concat(local.a_student_records, local.aaaa_student_records, local.a_docent_records, local.aaaa_docent_records)
  source  = "./modules/do_domain"
}

locals {
  # Compile student_vms to vm data
  student_vm_data = [
    for item in var.student_vms : {
      name    = item.student_number
      backups = item.backups
      image   = item.image
      size    = item.size
      # Add student number to tags
      tags    = ["student:${item.student_number}"]
    }
  ]

  # Compile docent_vms to vm data
  docent_vm_data = [
    for item in var.docent_vms : {
      name    = item.name
      backups = item.backups
      image   = item.image
      size    = item.size
      # Strip docent name of spaces and add it as a docent tag
      tags    = ["docent:${replace(item.docent_name, " ", "")}"]
    }
  ]
}

# Module that handles all the student vms
module "student_vms" {
  vms           = local.student_vm_data
  master_key_id = module.master_key.id
  source        = "./modules/vm_group"
}

# Module that handles all the docent vms
module "docent_vms" {
  vms           = local.docent_vm_data
  master_key_id = module.master_key.id
  source        = "./modules/vm_group"
}
