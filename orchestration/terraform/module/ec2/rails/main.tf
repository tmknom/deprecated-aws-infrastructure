resource "aws_instance" "rails" {
  count = "${var.instance_count}"

  ami = "${var.ami_id}"
  subnet_id = "${var.subnet_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.instance_profile}"
  security_groups = [
    "${var.security_group_id}",
    "${var.rds_security_group_id}",
    "${var.ssh_security_group_id}"
  ]

  associate_public_ip_address = true
  disable_api_termination = false

  root_block_device {
    volume_size = "${var.volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags {
    Name = "${var.environment}-${var.role}-${var.application}-${count.index}"

    Environment = "${var.environment}"
    Application = "${var.application}"
    Role = "${var.role}"

    DeploymentGroup = "${var.deployment_group}"
    Created = "${var.created}"
  }

  provisioner "local-exec" {
    command = "echo local-exec"
  }
}
