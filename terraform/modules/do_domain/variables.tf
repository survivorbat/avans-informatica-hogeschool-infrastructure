variable "domain" {
  type = string
}

variable "records" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}
