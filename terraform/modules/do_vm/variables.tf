variable "image" {
  type = string
}

variable "name" {
  type = string
}

variable "size" {
  type = string
}

variable "backups" {
  type    = bool
  default = false
}

variable "ssh_keys" {
  type = list(string)
}

variable "tags" {
  type    = list(string)
  default = []
}
