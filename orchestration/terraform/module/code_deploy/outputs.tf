output "production_deployment_group_name" {
  value = "${aws_codedeploy_deployment_group.production.deployment_group_name}"
}

output "testing_deployment_group_name" {
  value = "${aws_codedeploy_deployment_group.testing.deployment_group_name}"
}

output "application_name" {
  value = "${aws_codedeploy_app.application.name}"
}
