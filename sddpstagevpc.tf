resource "aws_vpc" "sddp_stage" {
  cidr_block           = "172.29.16.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "sddp_stage"
  }
}

resource "aws_subnet" "sddp_stage_public_subnet_a" {
  vpc_id     = "${aws_vpc.sddp_stage.id}"
  cidr_block = "172.29.16.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "sddp_stage_fe_a"
    Application = "sddp_stage"
    Tier        = "FE"
  }
}

resource "aws_subnet" "sddp_stage_public_subnet_b" {
  vpc_id     = "${aws_vpc.sddp_stage.id}"
  cidr_block = "172.29.17.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "sddp_stage_fe_b"
    Application = "sddp_stage"
    Tier        = "FE"
  }
}

resource "aws_subnet" "sddp_stage_public_subnet_c" {
  vpc_id     = "${aws_vpc.sddp_stage.id}"
  cidr_block = "172.29.18.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "sddp_stage_fe_c"
    Application = "sddp_stage"
    Tier        = "FE"
  }
}


resource "aws_subnet" "sddp_stage_be_subnet_a" {
  vpc_id                  = "${aws_vpc.sddp_stage.id}"
  cidr_block              = "172.29.19.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "sddp_stage_be_a"
    Application = "sddp_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "sddp_stage_be_subnet_b" {
  vpc_id                  = "${aws_vpc.sddp_stage.id}"
  cidr_block              = "172.29.20.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "sddp_stage_be_b"
    Application = "sddp_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "sddp_stage_be_subnet_c" {
  vpc_id            = "${aws_vpc.sddp_stage.id}"
  cidr_block        = "172.29.21.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "sddp_stage_be_c"
    Application = "sddp_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "sddp_stage_db_subnet_a" {
  vpc_id            = "${aws_vpc.sddp_stage.id}"
  cidr_block        = "172.29.22.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name        = "sddp_stage_db_a"
    Application = "sddp_stage"
    Tier        = "DB"
  }
}

resource "aws_subnet" "sddp_stage_db_subnet_b" {
  vpc_id            = "${aws_vpc.sddp_stage.id}"
  cidr_block        = "172.29.23.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name        = "sddp_stage_db_b"
    Application = "sddp_stage"
    Tier        = "DB"
  }
}

resource "aws_subnet" "sddp_stage_db_subnet_c" {
  vpc_id            = "${aws_vpc.sddp_stage.id}"
  cidr_block        = "172.29.24.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "sddp_stage_db_c"
    Application = "sddp_stage"
    Tier        = "DB"
  }
}

resource "aws_internet_gateway" "sddp_stage-ig" {
  vpc_id = "${aws_vpc.sddp_stage.id}"

  tags = {
    Name        = "sddp_stage IG"
    Application = "sddp_stage"
  }
}

resource "aws_route_table" "sddp_stage_public_routetable" {
  vpc_id = "${aws_vpc.sddp_stage.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.sddp_stage-ig.id}"
  }
  route {
    cidr_block = "${aws_vpc.general_stage.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.sddp_stage2general_stage.id}"
  }

  tags = {
    label = "sddp_stage"
    Name  = "sddp_stage_public_routetable"
  }
}

resource "aws_route_table_association" "sddp_stage_public_subnet_a" {
  subnet_id      = "${aws_subnet.sddp_stage_public_subnet_a.id}"
  route_table_id = "${aws_route_table.sddp_stage_public_routetable.id}"
}

resource "aws_route_table_association" "sddp_stage_public_subnet_b" {
  subnet_id      = "${aws_subnet.sddp_stage_public_subnet_b.id}"
  route_table_id = "${aws_route_table.sddp_stage_public_routetable.id}"
}

resource "aws_route_table_association" "sddp_stage_public_subnet_c" {
  subnet_id      = "${aws_subnet.sddp_stage_public_subnet_c.id}"
  route_table_id = "${aws_route_table.sddp_stage_public_routetable.id}"
}

resource "aws_eip" "sddp_stage_nat" {
  vpc = true
}

resource "aws_nat_gateway" "sddp_stage" {
  allocation_id = "${aws_eip.sddp_stage_nat.id}"
  subnet_id     = "${aws_subnet.sddp_stage_public_subnet_a.id}"

  tags = {
    Name = "sddp_stage VPC NAT"
  }
}

resource "aws_route_table" "sddp_stage_private_routetable" {
  vpc_id = "${aws_vpc.sddp_stage.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.sddp_stage.id}"
  }
  route {
    cidr_block = "${aws_vpc.general_stage.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.sddp_stage2general_stage.id}"
  }
  depends_on = ["aws_nat_gateway.sddp_stage"]

  tags = {
    label = "sddp_stage"
    Name  = "sddp_stage_private_routetable"
  }
}


resource "aws_route_table_association" "sddp_stage_be_subnet_a" {
  subnet_id      = "${aws_subnet.sddp_stage_be_subnet_a.id}"
  route_table_id = "${aws_route_table.sddp_stage_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_stage_be_subnet_b" {
  subnet_id      = "${aws_subnet.sddp_stage_be_subnet_b.id}"
  route_table_id = "${aws_route_table.sddp_stage_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_stage_be_subnet_c" {
  subnet_id      = "${aws_subnet.sddp_stage_be_subnet_c.id}"
  route_table_id = "${aws_route_table.sddp_stage_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_stage_db_subnet_a" {
  subnet_id      = "${aws_subnet.sddp_stage_db_subnet_a.id}"
  route_table_id = "${aws_route_table.sddp_stage_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_stage_db_subnet_b" {
  subnet_id      = "${aws_subnet.sddp_stage_db_subnet_b.id}"
  route_table_id = "${aws_route_table.sddp_stage_private_routetable.id}"
}

resource "aws_route_table_association" "sddp_stage_db_subnet_c" {
  subnet_id      = "${aws_subnet.sddp_stage_db_subnet_c.id}"
  route_table_id = "${aws_route_table.sddp_stage_private_routetable.id}"
}

resource "aws_vpc_peering_connection" "sddp_stage2general_stage" {
  vpc_id      = "${aws_vpc.sddp_stage.id}"
  peer_vpc_id = "${aws_vpc.general_stage.id}"
  auto_accept = true

  tags = {
    Name        = "sddp_stage VPC to general_stage VPC peering"
    Application = "sddp_stage"
    Company     = "Perform"
  }
}
