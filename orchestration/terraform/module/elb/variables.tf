variable "application" {
}

variable "environment" {
}

variable "subnets" {
}

variable "security_groups" {
}

variable "instance_port" {
  default = "80"
}

variable "instance_protocol" {
  default = "http"
}

variable "lb_port" {
  default = "80"
}

variable "lb_protocol" {
  default = "http"
}

variable "unhealthy_threshold" {
  default = 2
}

variable "healthy_threshold" {
  default = 10
}

variable "health_check_timeout" {
  default = 5
}

variable "health_check_target" {
  default = "HTTP:80/index.html"
}

variable "health_check_interval" {
  default = 30
}

variable "cross_zone_load_balancing" {
  default = true
}

variable "connection_draining" {
  default = true
}

variable "connection_draining_timeout" {
  default = 300
}

variable "idle_timeout" {
  default = 60
}
