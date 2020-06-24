variable "domain" {
  type        = string
  description = "Main domain to use"
  default     = "__domain__"
}

variable "do_token" {
  type        = string
  description = "Token to connect to the DigitalOcean API"
  default     = "__doToken__"
}

variable "master_key" {
  type        = string
  description = "Public master key to connect to VMs"
  default     = "__masterPublicKey__"
}

variable "student_vms" {
  type = map(object({
    student_number = string
    image          = string
    size           = string
    backups        = bool
  }))
  description = "List of student vms"
  default     = {}
}

variable "docent_vms" {
  type = map(object({
    subdomain   = string
    docent_name = string

    name    = string
    backups = bool
    image   = string
    size    = string
  }))
  description = "List of docent vms"
  default     = {}
}
