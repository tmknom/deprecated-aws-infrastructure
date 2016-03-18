variable "identifier" {
}

variable "suffix" {
}

variable "policy" {
}

variable "group" {
  default = "S3Log"
}

variable "acl" {
  default = "log-delivery-write"
}

variable "environment" {
  default = "Global"
}
