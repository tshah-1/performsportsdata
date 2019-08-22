resource "aws_vpc" "sddp" {
  cidr_block           = "172.24.48.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "sddp"
  }
}

resource "aws_subnet" "sddp_public_subnet_a" {
  vpc_id     = "${aws_vpc.sddp.id}"
  cidr_block = "172.24.48.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sddp_fe_a"
    Application = "sddp"
    Tier        = "FE"
  }
}

resource "aws_subnet" "sddp_public_subnet_b" {
  vpc_id     = "${aws_vpc.sddp.id}"
  cidr_block = "172.24.49.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sddp_fe_b"
    Application = "sddp"
    Tier        = "FE"
  }
}

resource "aws_subnet" "sddp_public_subnet_c" {
  vpc_id     = "${aws_vpc.sddp.id}"
  cidr_block = "172.24.50.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "sddp_fe_c"
    Application = "sddp"
    Tier        = "FE"
  }
}


resource "aws_subnet" "sddp_be_subnet_a" {
  vpc_id                  = "${aws_vpc.sddp.id}"
  cidr_block              = "172.24.51.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"

  tags {
    Name        = "sddp_be_a"
    Application = "sddp"
    Tier        = "BE"
  }
}

resource "aws_subnet" "sddp_be_subnet_b" {
  vpc_id                  = "${aws_vpc.sddp.id}"
  cidr_block              = "172.24.52.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"

  tags {
    Name        = "sddp_be_b"
    Application = "sddp"
    Tier        = "BE"
  }
}

resource "aws_subnet" "sddp_be_subnet_c" {
  vpc_id            = "${aws_vpc.sddp.id}"
  cidr_block        = "172.24.53.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "sddp_be_c"
    Application = "sddp"
    Tier = "BE"
  }
}

resource "aws_subnet" "sddp_db_subnet_a" {
  vpc_id            = "${aws_vpc.sddp.id}"
  cidr_block        = "172.24.54.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "sddp_db_a"
    Application = "sddp"
    Tier = "DB"
  }
}

resource "aws_subnet" "sddp_db_subnet_b" {
  vpc_id            = "${aws_vpc.sddp.id}"
  cidr_block        = "172.24.55.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name        = "sddp_db_b"
    Application = "sddp"
    Tier = "DB"
  }
}

resource "aws_subnet" "sddp_db_subnet_c" {
  vpc_id            = "${aws_vpc.sddp.id}"
  cidr_block        = "172.24.56.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "sddp_db_c"
    Application = "sddp"
    Tier = "DB"
  }
}

resource "aws_internet_gateway" "sddp-ig" {
  vpc_id = "${aws_vpc.sddp.id}"

  tags {
    Name        = "sddp IG"
    Application = "sddp"
  }
}

resource "aws_route_table" "sddp_public_routetable" {
  vpc_id = "${aws_vpc.sddp.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.sddp-ig.id}"
  }
  route {
    cidr_block = "${aws_vpc.general.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.sddp2general.id}"
  }

  tags {
    label = "sddp"
    Name = "sddp_public_routetable"
  }
}

resource "aws_route_table_association" "sddp_public_subnet_a" {
  subnet_id      = "${aws_subnet.sddp_public_subnet_a.id}"
  route_table_id = "${aws_route_table.sddp_public_routetable.id}"
}

resource "aws_route_table_association" "sddp_public_subnet_b" {
  subnet_id      = "${aws_subnet.sddp_public_subnet_b.id}"
  route_table_id = "${aws_route_table.sddp_public_routetable.id}"
}

resource "aws_route_table_association" "sddp_public_subnet_c" {
  subnet_id      = "${aws_subnet.sddp_public_subnet_c.id}"
  route_table_id = "${aws_route_table.sddp_public_routetable.id}"
}

resource "aws_eip" "sddp_nat" {
  vpc = true
}

resource "aws_nat_gateway" "sddp" {
  allocation_id = "${aws_eip.sddp_nat.id}"
  subnet_id     = "${aws_subnet.sddp_public_subnet_a.id}"

  tags {
    Name = "sddp VPC NAT"
  }
}

resource "aws_route_table" "sddp_private_routetable" {
  vpc_id = "${aws_vpc.sddp.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.sddp.id}"
  }
  route {
    cidr_block = "${aws_vpc.general.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.sddp2general.id}"
  }
  depends_on = ["aws_nat_gateway.sddp"]

  tags {
    label = "sddp"
    Name = "sddp_private_routetable"
  }
}


resource "aws_route_table_association" "sddp_be_subnet_a" {
  subnet_id      = "${aws_subnet.sddp_be_subnet_a.id}"
  route_table_id = "${aws_route_table.sddp_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_be_subnet_b" {
  subnet_id      = "${aws_subnet.sddp_be_subnet_b.id}"
  route_table_id = "${aws_route_table.sddp_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_be_subnet_c" {
  subnet_id      = "${aws_subnet.sddp_be_subnet_c.id}"
  route_table_id = "${aws_route_table.sddp_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_db_subnet_a" {
  subnet_id      = "${aws_subnet.sddp_db_subnet_a.id}"
  route_table_id = "${aws_route_table.sddp_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_db_subnet_b" {
  subnet_id      = "${aws_subnet.sddp_db_subnet_b.id}"
  route_table_id = "${aws_route_table.sddp_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_db_subnet_c" {
  subnet_id      = "${aws_subnet.sddp_db_subnet_c.id}"
  route_table_id = "${aws_route_table.sddp_private_routetable.id}"
}

resource "aws_vpc_peering_connection" "sddp2general" {
  vpc_id      = "${aws_vpc.sddp.id}"
  peer_vpc_id = "${aws_vpc.general.id}"
  auto_accept = true

  tags = {
    Name        = "sddp VPC to general VPC peering"
    Application = "sddp"
    Company     = "Perform"
  }
}
