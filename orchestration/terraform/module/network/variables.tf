variable "environment" {
}
variable "vpc_cidr" {
}

variable "enable_dns_hostnames" {
  default = true
}
variable "enable_dns_support" {
  default = true
}

variable "default_route" {
  default = "0.0.0.0/0"
}

variable "region" {
  default = "ap-northeast-1"
}
