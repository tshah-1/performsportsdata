resource "aws_vpc" "esportsstaging" {
  cidr_block           = "172.29.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "esportsstaging"
  }
}

resource "aws_subnet" "esportsstaging_public_subnet_a" {
  vpc_id     = "${aws_vpc.esportsstaging.id}"
  cidr_block = "172.29.1.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "esportsstaging_fe_a"
    Application = "esportsstaging"
    Tier        = "FE"
  }
}

resource "aws_subnet" "esportsstaging_public_subnet_b" {
  vpc_id     = "${aws_vpc.esportsstaging.id}"
  cidr_block = "172.29.2.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "esportsstaging_fe_b"
    Application = "esportsstaging"
    Tier        = "FE"
  }
}

resource "aws_subnet" "esportsstaging_public_subnet_c" {
  vpc_id     = "${aws_vpc.esportsstaging.id}"
  cidr_block = "172.29.3.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "esportsstaging_fe_c"
    Application = "esportsstaging"
    Tier        = "FE"
  }
}

resource "aws_subnet" "esportsstaging_be_subnet_a" {
  vpc_id                  = "${aws_vpc.esportsstaging.id}"
  cidr_block              = "172.29.4.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "esportsstaging_be_a"
    Application = "esportsstaging"
    Tier        = "BE"
  }
}

resource "aws_subnet" "esportsstaging_be_subnet_b" {
  vpc_id                  = "${aws_vpc.esportsstaging.id}"
  cidr_block              = "172.29.5.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "esportsstaging_be_b"
    Application = "esportsstaging"
    Tier        = "BE"
  }
}

resource "aws_subnet" "esportsstaging_be_subnet_c" {
  vpc_id            = "${aws_vpc.esportsstaging.id}"
  cidr_block        = "172.29.6.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "esportsstaging_be_c"
    Application = "esportsstaging"
    Tier        = "BE"
  }
}

resource "aws_subnet" "esportsstaging_db_subnet_a" {
  vpc_id            = "${aws_vpc.esportsstaging.id}"
  cidr_block        = "172.29.7.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name        = "esportsstaging_db_a"
    Application = "esportsstaging"
    Tier        = "DB"
  }
}

resource "aws_subnet" "esportsstaging_db_subnet_b" {
  vpc_id            = "${aws_vpc.esportsstaging.id}"
  cidr_block        = "172.29.8.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name        = "esportsstaging_db_b"
    Application = "esportsstaging"
    Tier        = "DB"
  }
}

resource "aws_subnet" "esportsstaging_db_subnet_c" {
  vpc_id            = "${aws_vpc.esportsstaging.id}"
  cidr_block        = "172.29.9.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "esportsstaging_db_c"
    Application = "esportsstaging"
    Tier        = "DB"
  }
}

resource "aws_internet_gateway" "esportsstaging-ig" {
  vpc_id = "${aws_vpc.esportsstaging.id}"

  tags = {
    Name        = "esportsstaging IG"
    Application = "esportsstaging"
  }
}

resource "aws_route_table" "esportsstaging_public_routetable" {
  vpc_id = "${aws_vpc.esportsstaging.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.esportsstaging-ig.id}"
  }

  tags = {
    label = "esportsstaging"
    Name  = "esportsstaging_public_routetable"
  }
}

resource "aws_route_table_association" "esportsstaging_public_subnet_a" {
  subnet_id      = "${aws_subnet.esportsstaging_public_subnet_a.id}"
  route_table_id = "${aws_route_table.esportsstaging_public_routetable.id}"
}

resource "aws_route_table_association" "esportsstaging_public_subnet_b" {
  subnet_id      = "${aws_subnet.esportsstaging_public_subnet_b.id}"
  route_table_id = "${aws_route_table.esportsstaging_public_routetable.id}"
}

resource "aws_route_table_association" "esportsstaging_public_subnet_c" {
  subnet_id      = "${aws_subnet.esportsstaging_public_subnet_c.id}"
  route_table_id = "${aws_route_table.esportsstaging_public_routetable.id}"
}

resource "aws_eip" "esportsstaging_nat" {
  vpc = true
}

resource "aws_nat_gateway" "esportsstaging" {
  allocation_id = "${aws_eip.esportsstaging_nat.id}"
  subnet_id     = "${aws_subnet.esportsstaging_public_subnet_a.id}"

  tags = {
    Name = "esportsstaging VPC NAT"
  }
}

resource "aws_route_table" "esportsstaging_private_routetable" {
  vpc_id = "${aws_vpc.esportsstaging.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.esportsstaging.id}"
  }
  depends_on = ["aws_nat_gateway.esportsstaging"]

  tags = {
    label = "esportsstaging"
    Name  = "esportsstaging_private_routetable"
  }
}


resource "aws_route_table_association" "esportsstaging_be_subnet_a" {
  subnet_id      = "${aws_subnet.esportsstaging_be_subnet_a.id}"
  route_table_id = "${aws_route_table.esportsstaging_private_routetable.id}"
}

resource "aws_route_table_association" "esportsstaging_be_subnet_b" {
  subnet_id      = "${aws_subnet.esportsstaging_be_subnet_b.id}"
  route_table_id = "${aws_route_table.esportsstaging_private_routetable.id}"
}

resource "aws_route_table_association" "esportsstaging_be_subnet_c" {
  subnet_id      = "${aws_subnet.esportsstaging_be_subnet_c.id}"
  route_table_id = "${aws_route_table.esportsstaging_private_routetable.id}"
}

resource "aws_route_table_association" "esportsstaging_db_subnet_a" {
  subnet_id      = "${aws_subnet.esportsstaging_db_subnet_a.id}"
  route_table_id = "${aws_route_table.esportsstaging_private_routetable.id}"
}

resource "aws_route_table_association" "esportsstaging_db_subnet_b" {
  subnet_id      = "${aws_subnet.esportsstaging_db_subnet_b.id}"
  route_table_id = "${aws_route_table.esportsstaging_private_routetable.id}"
}

resource "aws_route_table_association" "esportsstaging_db_subnet_c" {
  subnet_id      = "${aws_subnet.esportsstaging_db_subnet_c.id}"
  route_table_id = "${aws_route_table.esportsstaging_private_routetable.id}"
}

