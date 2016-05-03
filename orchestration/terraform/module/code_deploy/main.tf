resource "aws_codedeploy_deployment_group" "production" {
  deployment_group_name = "production-${aws_codedeploy_app.application.name}"

  app_name = "${aws_codedeploy_app.application.name}"
  service_role_arn = "${var.role_arn}"
  deployment_config_name = "${var.deployment_config_name}"

  ec2_tag_filter {
    key = "DeploymentGroup"
    value = "${aws_codedeploy_app.application.name}"
    type = "KEY_AND_VALUE"
  }

  ec2_tag_filter {
    key = "Environment"
    value = "Production"
    type = "KEY_AND_VALUE"
  }
}

resource "aws_codedeploy_deployment_group" "administration" {
  deployment_group_name = "administration-${aws_codedeploy_app.application.name}"

  app_name = "${aws_codedeploy_app.application.name}"
  service_role_arn = "${var.role_arn}"
  deployment_config_name = "${var.deployment_config_name}"

  ec2_tag_filter {
    key = "DeploymentGroup"
    value = "${aws_codedeploy_app.application.name}"
    type = "KEY_AND_VALUE"
  }

  ec2_tag_filter {
    key = "Environment"
    value = "Administration"
    type = "KEY_AND_VALUE"
  }
}

resource "aws_codedeploy_app" "application" {
  name = "${var.application_name}"
}
