variable "description" {
  type    = string
  default = "A project created using Terraform"
}

variable "name" {
  type = string
}

variable "purpose" {
  type    = string
  default = "Other"
}

variable "environment" {
  type    = string
  default = "Development"
}

variable "resources" {
  type    = list(string)
  default = []
}
