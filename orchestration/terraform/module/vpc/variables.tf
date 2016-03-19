variable "environment" {
}

variable "region_name" {
}

variable "vpc_cidr" {
}

variable "availability_zones" {
}

variable "public_subnets" {
  default = ""
}

variable "protected_subnets" {
  default = ""
}

variable "private_subnets" {
  default = ""
}

variable "public_network" {
  default = "Public"
}

variable "protected_network" {
  default = "Protected"
}

variable "private_network" {
  default = "Private"
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
