resource "aws_cloudtrail" "cloud_trail" {
  name = "${var.name}"
  s3_bucket_name = "${var.bucket_name}"

  enable_logging = true
  is_multi_region_trail = true
  include_global_service_events = true
  enable_log_file_validation = true
}
