variable "vpc_name" {
}
variable "vpc_cidr" {
}

variable "enable_dns_hostnames" {
  default = true
}
variable "enable_dns_support" {
  default = true
}

variable "region" {
  default = "ap-northeast-1"
}
