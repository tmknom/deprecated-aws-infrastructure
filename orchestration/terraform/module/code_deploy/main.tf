provider "aws" {
  region = "${var.region}"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name = "${aws_codedeploy_app.application.name}"
  deployment_group_name = "${var.deployment_group_name}"
  service_role_arn = "${var.role_arn}"
  deployment_config_name = "${var.deployment_config_name}"
  ec2_tag_filter {
    key = "${var.ec2_tag_filter_key}"
    value = "${aws_codedeploy_app.application.name}"
    type = "KEY_AND_VALUE"
  }
}

resource "aws_codedeploy_app" "application" {
  name = "${var.application_name}"
}
