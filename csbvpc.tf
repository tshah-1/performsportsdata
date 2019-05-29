resource "aws_vpc" "csb" {
  cidr_block           = "172.24.32.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "csb"
  }
}

resource "aws_subnet" "csb_public_subnet_a" {
  vpc_id     = "${aws_vpc.csb.id}"
  cidr_block = "172.24.32.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "csb_fe_a"
    Application = "csb"
    Tier        = "FE"
  }
}

resource "aws_subnet" "csb_public_subnet_b" {
  vpc_id     = "${aws_vpc.csb.id}"
  cidr_block = "172.24.33.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "csb_fe_b"
    Application = "csb"
    Tier        = "FE"
  }
}

resource "aws_subnet" "csb_public_subnet_c" {
  vpc_id     = "${aws_vpc.csb.id}"
  cidr_block = "172.24.34.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "csb_fe_c"
    Application = "csb"
    Tier        = "FE"
  }
}


resource "aws_subnet" "csb_be_subnet_a" {
  vpc_id                  = "${aws_vpc.csb.id}"
  cidr_block              = "172.24.35.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"

  tags {
    Name        = "csb_be_a"
    Application = "csb"
    Tier        = "BE"
  }
}

resource "aws_subnet" "csb_be_subnet_b" {
  vpc_id                  = "${aws_vpc.csb.id}"
  cidr_block              = "172.24.36.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"

  tags {
    Name        = "csb_be_b"
    Application = "csb"
    Tier        = "BE"
  }
}

resource "aws_subnet" "csb_be_subnet_c" {
  vpc_id            = "${aws_vpc.csb.id}"
  cidr_block        = "172.24.37.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "csb_be_b"
    Application = "csb"
    Tier = "BE"
  }
}

resource "aws_subnet" "csb_db_subnet_a" {
  vpc_id            = "${aws_vpc.csb.id}"
  cidr_block        = "172.24.38.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name        = "csb_db_a"
    Application = "csb"
    Tier = "DB"
  }
}

resource "aws_subnet" "csb_db_subnet_b" {
  vpc_id            = "${aws_vpc.csb.id}"
  cidr_block        = "172.24.39.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "csb_db_b"
    Application = "csb"
    Tier = "DB"
  }
}

resource "aws_subnet" "csb_db_subnet_c" {
  vpc_id            = "${aws_vpc.csb.id}"
  cidr_block        = "172.24.40.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "csb_db_c"
    Application = "csb"
    Tier = "DB"
  }
}

resource "aws_internet_gateway" "csb-ig" {
  vpc_id = "${aws_vpc.csb.id}"

  tags {
    Name        = "csb IG"
    Application = "csb"
  }
}

resource "aws_route_table" "csb_public_routetable" {
  vpc_id = "${aws_vpc.csb.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.csb-ig.id}"
  }

  tags {
    label = "csb"
  }
}

resource "aws_route_table_association" "csb_public_subnet_a" {
  subnet_id      = "${aws_subnet.csb_public_subnet_a.id}"
  route_table_id = "${aws_route_table.csb_public_routetable.id}"
}

resource "aws_route_table_association" "csb_public_subnet_b" {
  subnet_id      = "${aws_subnet.csb_public_subnet_b.id}"
  route_table_id = "${aws_route_table.csb_public_routetable.id}"
}

resource "aws_route_table_association" "csb_public_subnet_c" {
  subnet_id      = "${aws_subnet.csb_public_subnet_c.id}"
  route_table_id = "${aws_route_table.csb_public_routetable.id}"
}

resource "aws_eip" "csb_nat" {
  vpc = true
}

resource "aws_nat_gateway" "csb" {
  allocation_id = "${aws_eip.csb_nat.id}"
  subnet_id     = "${aws_subnet.csb_public_subnet_a.id}"

  tags {
    Name = "csb VPC NAT"
  }
}

resource "aws_route_table" "csb_private_routetable" {
  vpc_id = "${aws_vpc.csb.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.csb.id}"
  }
  depends_on = ["aws_nat_gateway.csb"]

  tags {
    label = "csb"
  }
}


resource "aws_route_table_association" "csb_be_subnet_a" {
  subnet_id      = "${aws_subnet.csb_be_subnet_a.id}"
  route_table_id = "${aws_route_table.csb_private_routetable.id}"
}

resource "aws_route_table_association" "csb_be_subnet_b" {
  subnet_id      = "${aws_subnet.csb_be_subnet_b.id}"
  route_table_id = "${aws_route_table.csb_private_routetable.id}"
}

resource "aws_route_table_association" "csb_be_subnet_c" {
  subnet_id      = "${aws_subnet.csb_be_subnet_c.id}"
  route_table_id = "${aws_route_table.csb_private_routetable.id}"
}

resource "aws_route_table_association" "csb_db_subnet_a" {
  subnet_id      = "${aws_subnet.csb_db_subnet_a.id}"
  route_table_id = "${aws_route_table.csb_private_routetable.id}"
}

resource "aws_route_table_association" "csb_db_subnet_b" {
  subnet_id      = "${aws_subnet.csb_db_subnet_b.id}"
  route_table_id = "${aws_route_table.csb_private_routetable.id}"
}

resource "aws_route_table_association" "csb_db_subnet_c" {
  subnet_id      = "${aws_subnet.csb_db_subnet_c.id}"
  route_table_id = "${aws_route_table.csb_private_routetable.id}"
}
