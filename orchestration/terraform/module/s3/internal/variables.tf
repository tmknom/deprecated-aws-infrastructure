variable "identifier" {
}

variable "suffix" {
}

variable "policy" {
}

variable "log_identifier" {
  default = "s3-log"
}

variable "group" {
  default = "Internal"
}

variable "acl" {
  default = "private"
}

variable "environment" {
  default = "Administration"
}
