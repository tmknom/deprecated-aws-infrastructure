output "bucket_arn" {
  value = "${aws_s3_bucket.log_bucket.arn}"
}

output "bucket_name" {
  value = "${aws_s3_bucket.log_bucket.id}"
}

output "bucket_identifier" {
  value = "${aws_s3_bucket.log_bucket.tags.Identifier}"
}

output "bucket_group" {
  value = "${aws_s3_bucket.log_bucket.tags.Group}"
}

output "bucket_environment" {
  value = "${aws_s3_bucket.log_bucket.tags.Environment}"
}
