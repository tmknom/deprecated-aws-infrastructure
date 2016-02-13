variable "application_name" {
}

variable "deployment_config_name" {
  default = "CodeDeployDefault.OneAtATime"
}

variable "ec2_tag_filter_key" {
  default = "Name"
}

variable "role_arn" {
}
