variable "keys" {
  type = "map"

  default = {
    "eu-west-2"      = "sportsdata_london"
  }
}

resource "aws_instance" "cpoc-sdb01" {
  ami                         = "ami-0eab3a90fc693af19"
  key_name                    = "${var.keys["${terraform.workspace}"]}"
  instance_type               = "m5.4xlarge"
  vpc_security_group_ids      = ["${aws_security_group.oc_mysqlslave.id}"]
  subnet_id                   = "${aws_subnet.optacore_prod_db_subnet_a.id}"
  count                       = "1"
  associate_public_ip_address = "false"
  ebs_block_device {
	device_name		      = "/dev/sda1"
	volume_size		      = "250"
	volume_type		      = "gp2"
}
  tags = {
    Name = "cpoc-sdb01"
  }
}
