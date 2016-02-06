variable "application_name" {
}

variable "deployment_group_name" {
}

variable "deployment_config_name" {
  default = "CodeDeployDefault.OneAtATime"
}

variable "ec2_tag_filter_key" {
  default = "Name"
}

variable "role_arn" {
}

variable "region" {
  default = "ap-northeast-1"
}
