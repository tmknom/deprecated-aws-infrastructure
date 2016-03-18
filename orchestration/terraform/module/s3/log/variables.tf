variable "identifier" {
}

variable "suffix" {
}

variable "policy" {
}

variable "group" {
  default = "Log"
}

variable "acl" {
  default = "log-delivery-write"
}

variable "environment" {
  default = "Global"
}
