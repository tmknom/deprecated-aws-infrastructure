output "trail_arn" {
  value = "${aws_cloudtrail.cloud_trail.arn}"
}

output "trail_name" {
  value = "${aws_cloudtrail.cloud_trail.id}"
}
