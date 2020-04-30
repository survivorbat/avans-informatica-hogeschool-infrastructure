variable "master_key_id" {
  type = string
  description = "Id of the master key in Digital Ocean"
}

variable "vms" {
  type = list(object({
    name = string
    backups = bool
    image = string
    size = string
    tags = list(string)
  }))
  description = "List requested vms"
  default = []
}
