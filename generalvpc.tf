resource "aws_vpc" "general" {
  cidr_block           = "172.24.80.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "general"
  }
}

resource "aws_subnet" "general_public_subnet_a" {
  vpc_id     = "${aws_vpc.general.id}"
  cidr_block = "172.24.80.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "general_fe_a"
    Application = "general"
    Tier        = "FE"
  }
}

resource "aws_subnet" "general_public_subnet_b" {
  vpc_id     = "${aws_vpc.general.id}"
  cidr_block = "172.24.81.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "general_fe_b"
    Application = "general"
    Tier        = "FE"
  }
}

resource "aws_subnet" "general_public_subnet_c" {
  vpc_id     = "${aws_vpc.general.id}"
  cidr_block = "172.24.82.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "general_fe_c"
    Application = "general"
    Tier        = "FE"
  }
}


resource "aws_subnet" "general_be_subnet_a" {
  vpc_id                  = "${aws_vpc.general.id}"
  cidr_block              = "172.24.83.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "general_be_a"
    Application = "general"
    Tier        = "BE"
  }
}

resource "aws_subnet" "general_be_subnet_b" {
  vpc_id                  = "${aws_vpc.general.id}"
  cidr_block              = "172.24.84.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "general_be_b"
    Application = "general"
    Tier        = "BE"
  }
}

resource "aws_subnet" "general_be_subnet_c" {
  vpc_id            = "${aws_vpc.general.id}"
  cidr_block        = "172.24.85.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "general_be_c"
    Application = "general"
    Tier        = "BE"
  }
}

resource "aws_subnet" "general_db_subnet_a" {
  vpc_id            = "${aws_vpc.general.id}"
  cidr_block        = "172.24.86.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name        = "general_db_a"
    Application = "general"
    Tier        = "DB"
  }
}

resource "aws_subnet" "general_db_subnet_b" {
  vpc_id            = "${aws_vpc.general.id}"
  cidr_block        = "172.24.87.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name        = "general_db_b"
    Application = "general"
    Tier        = "DB"
  }
}

resource "aws_subnet" "general_db_subnet_c" {
  vpc_id            = "${aws_vpc.general.id}"
  cidr_block        = "172.24.88.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "general_db_c"
    Application = "general"
    Tier        = "DB"
  }
}

resource "aws_internet_gateway" "general-ig" {
  vpc_id = "${aws_vpc.general.id}"

  tags = {
    Name        = "general IG"
    Application = "general"
  }
}

resource "aws_route_table" "general_public_routetable" {
  vpc_id = "${aws_vpc.general.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.general-ig.id}"
  }
  route {
    cidr_block = "${aws_vpc.sddp.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.sddp2general.id}"
  }
  route {
    cidr_block = "${aws_vpc.csb.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.csb2general.id}"
  }

  tags = {
    label = "general"
    Name  = "general_public_routetable"
  }
}

resource "aws_route_table_association" "general_public_subnet_a" {
  subnet_id      = "${aws_subnet.general_public_subnet_a.id}"
  route_table_id = "${aws_route_table.general_public_routetable.id}"
}

resource "aws_route_table_association" "general_public_subnet_b" {
  subnet_id      = "${aws_subnet.general_public_subnet_b.id}"
  route_table_id = "${aws_route_table.general_public_routetable.id}"
}

resource "aws_route_table_association" "general_public_subnet_c" {
  subnet_id      = "${aws_subnet.general_public_subnet_c.id}"
  route_table_id = "${aws_route_table.general_public_routetable.id}"
}

resource "aws_eip" "general_nat" {
  vpc = true
}

resource "aws_nat_gateway" "general" {
  allocation_id = "${aws_eip.general_nat.id}"
  subnet_id     = "${aws_subnet.general_public_subnet_a.id}"

  tags = {
    Name = "general VPC NAT"
  }
}

resource "aws_route_table" "general_private_routetable" {
  vpc_id = "${aws_vpc.general.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.general.id}"
  }
  route {
    cidr_block = "${aws_vpc.sddp.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.sddp2general.id}"
  }
  route {
    cidr_block = "${aws_vpc.csb.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.csb2general.id}"
  }
  depends_on = ["aws_nat_gateway.general"]

  tags = {
    label = "general"
    Name  = "general_private_routetable"
  }
}


resource "aws_route_table_association" "general_be_subnet_a" {
  subnet_id      = "${aws_subnet.general_be_subnet_a.id}"
  route_table_id = "${aws_route_table.general_private_routetable.id}"
}

resource "aws_route_table_association" "general_be_subnet_b" {
  subnet_id      = "${aws_subnet.general_be_subnet_b.id}"
  route_table_id = "${aws_route_table.general_private_routetable.id}"
}

resource "aws_route_table_association" "general_be_subnet_c" {
  subnet_id      = "${aws_subnet.general_be_subnet_c.id}"
  route_table_id = "${aws_route_table.general_private_routetable.id}"
}

resource "aws_route_table_association" "general_db_subnet_a" {
  subnet_id      = "${aws_subnet.general_db_subnet_a.id}"
  route_table_id = "${aws_route_table.general_private_routetable.id}"
}

resource "aws_route_table_association" "general_db_subnet_b" {
  subnet_id      = "${aws_subnet.general_db_subnet_b.id}"
  route_table_id = "${aws_route_table.general_private_routetable.id}"
}

resource "aws_route_table_association" "general_db_subnet_c" {
  subnet_id      = "${aws_subnet.general_db_subnet_c.id}"
  route_table_id = "${aws_route_table.general_private_routetable.id}"
}
