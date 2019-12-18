resource "aws_security_group" "oc_mysqlslave" {
  name        = "oc_mysqlslave"
  description = "OC mysql slave access SG"
  vpc_id      = "vpc-0548054043f3a866a"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.12.52.0/24", "82.25.7.144/32", "62.253.83.190/32", "109.73.148.70/32", "172.24.112.0/24"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.12.52.0/24"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "OC slave DB SG"
    Application = "opta core"
  }
}
