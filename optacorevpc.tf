resource "aws_vpc" "optacore_stage" {
  cidr_block           = "172.24.20.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "optacore_stage"
  }
}

resource "aws_subnet" "optacore_stage_public_subnet_a" {
  vpc_id     = "${aws_vpc.optacore_stage.id}"
  cidr_block = "172.24.112.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "optacore_stage_fe_a"
    Application = "optacore_stage"
    Tier        = "FE"
  }
}

resource "aws_subnet" "optacore_stage_public_subnet_b" {
  vpc_id     = "${aws_vpc.optacore_stage.id}"
  cidr_block = "172.24.113.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "optacore_stage_fe_b"
    Application = "optacore_stage"
    Tier        = "FE"
  }
}

resource "aws_subnet" "optacore_stage_public_subnet_c" {
  vpc_id     = "${aws_vpc.optacore_stage.id}"
  cidr_block = "172.24.114.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "optacore_stage_fe_c"
    Application = "optacore_stage"
    Tier        = "FE"
  }
}


resource "aws_subnet" "optacore_stage_be_subnet_a" {
  vpc_id                  = "${aws_vpc.optacore_stage.id}"
  cidr_block              = "172.24.115.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "optacore_stage_be_a"
    Application = "optacore_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "optacore_stage_be_subnet_b" {
  vpc_id                  = "${aws_vpc.optacore_stage.id}"
  cidr_block              = "172.24.116.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "optacore_stage_be_b"
    Application = "optacore_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "optacore_stage_be_subnet_c" {
  vpc_id            = "${aws_vpc.optacore_stage.id}"
  cidr_block        = "172.24.117.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "optacore_stage_be_c"
    Application = "optacore_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "optacore_stage_db_subnet_a" {
  vpc_id            = "${aws_vpc.optacore_stage.id}"
  cidr_block        = "172.24.118.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name        = "optacore_stage_db_a"
    Application = "optacore_stage"
    Tier        = "DB"
  }
}

resource "aws_subnet" "optacore_stage_db_subnet_b" {
  vpc_id            = "${aws_vpc.optacore_stage.id}"
  cidr_block        = "172.24.119.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name        = "optacore_stage_db_b"
    Application = "optacore_stage"
    Tier        = "DB"
  }
}

resource "aws_subnet" "optacore_stage_db_subnet_c" {
  vpc_id            = "${aws_vpc.optacore_stage.id}"
  cidr_block        = "172.24.120.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "optacore_stage_db_c"
    Application = "optacore_stage"
    Tier        = "DB"
  }
}

resource "aws_internet_gateway" "optacore_stage-ig" {
  vpc_id = "${aws_vpc.optacore_stage.id}"

  tags = {
    Name        = "optacore_stage IG"
    Application = "optacore_stage"
  }
}

resource "aws_route_table" "optacore_stage_public_routetable" {
  vpc_id = "${aws_vpc.optacore_stage.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.optacore_stage-ig.id}"
  }
  route {
    cidr_block                = "${aws_vpc.general_stage.cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.optacore_stage2general_stage.id}"
  }

  tags = {
    label = "optacore_stage"
    Name  = "optacore_stage_public_routetable"
  }
}

resource "aws_route_table_association" "optacore_stage_public_subnet_a" {
  subnet_id      = "${aws_subnet.optacore_stage_public_subnet_a.id}"
  route_table_id = "${aws_route_table.optacore_stage_public_routetable.id}"
}

resource "aws_route_table_association" "optacore_stage_public_subnet_b" {
  subnet_id      = "${aws_subnet.optacore_stage_public_subnet_b.id}"
  route_table_id = "${aws_route_table.optacore_stage_public_routetable.id}"
}

resource "aws_route_table_association" "optacore_stage_public_subnet_c" {
  subnet_id      = "${aws_subnet.optacore_stage_public_subnet_c.id}"
  route_table_id = "${aws_route_table.optacore_stage_public_routetable.id}"
}

resource "aws_eip" "optacore_stage_nat" {
  vpc = true
}

resource "aws_nat_gateway" "optacore_stage" {
  allocation_id = "${aws_eip.optacore_stage_nat.id}"
  subnet_id     = "${aws_subnet.optacore_stage_public_subnet_a.id}"

  tags = {
    Name = "optacore_stage VPC NAT"
  }
}

resource "aws_route_table" "optacore_stage_private_routetable" {
  vpc_id = "${aws_vpc.optacore_stage.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.optacore_stage.id}"
  }
  route {
    cidr_block                = "${aws_vpc.general_stage.cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.optacore_stage2general_stage.id}"
  }
  depends_on = ["aws_nat_gateway.optacore_stage"]

  tags = {
    label = "optacore_stage"
    Name  = "optacore_stage_private_routetable"
  }
}


resource "aws_route_table_association" "optacore_stage_be_subnet_a" {
  subnet_id      = "${aws_subnet.optacore_stage_be_subnet_a.id}"
  route_table_id = "${aws_route_table.optacore_stage_private_routetable.id}"
}

resource "aws_route_table_association" "optacore_stage_be_subnet_b" {
  subnet_id      = "${aws_subnet.optacore_stage_be_subnet_b.id}"
  route_table_id = "${aws_route_table.optacore_stage_private_routetable.id}"
}

resource "aws_route_table_association" "optacore_stage_be_subnet_c" {
  subnet_id      = "${aws_subnet.optacore_stage_be_subnet_c.id}"
  route_table_id = "${aws_route_table.optacore_stage_private_routetable.id}"
}

resource "aws_route_table_association" "optacore_stage_db_subnet_a" {
  subnet_id      = "${aws_subnet.optacore_stage_db_subnet_a.id}"
  route_table_id = "${aws_route_table.optacore_stage_private_routetable.id}"
}

resource "aws_route_table_association" "optacore_stage_db_subnet_b" {
  subnet_id      = "${aws_subnet.optacore_stage_db_subnet_b.id}"
  route_table_id = "${aws_route_table.optacore_stage_private_routetable.id}"
}

resource "aws_route_table_association" "optacore_stage_db_subnet_c" {
  subnet_id      = "${aws_subnet.optacore_stage_db_subnet_c.id}"
  route_table_id = "${aws_route_table.optacore_stage_private_routetable.id}"
}

resource "aws_vpc_peering_connection" "optacore_stage2general_stage" {
  vpc_id      = "${aws_vpc.optacore_stage.id}"
  peer_vpc_id = "${aws_vpc.general_stage.id}"
  auto_accept = true

  tags = {
    Name        = "optacore_stage VPC to general_stage VPC peering"
    Application = "optacore_stage"
    Company     = "Perform"
  }
}
