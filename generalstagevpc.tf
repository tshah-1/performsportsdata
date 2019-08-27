resource "aws_vpc" "general_stage" {
  cidr_block           = "172.29.32.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "general_stage"
  }
}

resource "aws_subnet" "general_stage_public_subnet_a" {
  vpc_id     = "${aws_vpc.general_stage.id}"
  cidr_block = "172.29.32.0/20"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "general_stage_fe_a"
    Application = "general_stage"
    Tier        = "FE"
  }
}

resource "aws_subnet" "general_stage_public_subnet_b" {
  vpc_id     = "${aws_vpc.general_stage.id}"
  cidr_block = "172.29.33.0/20"

  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "general_stage_fe_b"
    Application = "general_stage"
    Tier        = "FE"
  }
}

resource "aws_subnet" "general_stage_public_subnet_c" {
  vpc_id     = "${aws_vpc.general_stage.id}"
  cidr_block = "172.29.34.0/20"

  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "general_stage_fe_c"
    Application = "general_stage"
    Tier        = "FE"
  }
}


resource "aws_subnet" "general_stage_be_subnet_a" {
  vpc_id                  = "${aws_vpc.general_stage.id}"
  cidr_block              = "172.29.35.0/20"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "general_stage_be_a"
    Application = "general_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "general_stage_be_subnet_b" {
  vpc_id                  = "${aws_vpc.general_stage.id}"
  cidr_block              = "172.29.36.0/20"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "general_stage_be_b"
    Application = "general_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "general_stage_be_subnet_c" {
  vpc_id            = "${aws_vpc.general_stage.id}"
  cidr_block        = "172.29.37.0/20"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "general_stage_be_c"
    Application = "general_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "general_stage_db_subnet_a" {
  vpc_id            = "${aws_vpc.general_stage.id}"
  cidr_block        = "172.29.38.0/20"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name        = "general_stage_db_a"
    Application = "general_stage"
    Tier        = "DB"
  }
}

resource "aws_subnet" "general_stage_db_subnet_b" {
  vpc_id            = "${aws_vpc.general_stage.id}"
  cidr_block        = "172.29.39.0/20"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name        = "general_stage_db_b"
    Application = "general_stage"
    Tier        = "DB"
  }
}

resource "aws_subnet" "general_stage_db_subnet_c" {
  vpc_id            = "${aws_vpc.general_stage.id}"
  cidr_block        = "172.24.88.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "general_stage_db_c"
    Application = "general_stage"
    Tier        = "DB"
  }
}

resource "aws_internet_gateway" "general_stage-ig" {
  vpc_id = "${aws_vpc.general_stage.id}"

  tags = {
    Name        = "general_stage IG"
    Application = "general_stage"
  }
}

resource "aws_route_table" "general_stage_public_routetable" {
  vpc_id = "${aws_vpc.general_stage.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.general_stage-ig.id}"
  }
  route {
    cidr_block = "${aws_vpc.sddp_stage.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.sddp_stage2general_stage.id}"
  }
  route {
    cidr_block = "${aws_vpc.csb_stage.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.csb_stage2general_stage.id}"
  }

  tags = {
    label = "general_stage"
    Name  = "general_stage_public_routetable"
  }
}

resource "aws_route_table_association" "general_stage_public_subnet_a" {
  subnet_id      = "${aws_subnet.general_stage_public_subnet_a.id}"
  route_table_id = "${aws_route_table.general_stage_public_routetable.id}"
}

resource "aws_route_table_association" "general_stage_public_subnet_b" {
  subnet_id      = "${aws_subnet.general_stage_public_subnet_b.id}"
  route_table_id = "${aws_route_table.general_stage_public_routetable.id}"
}

resource "aws_route_table_association" "general_stage_public_subnet_c" {
  subnet_id      = "${aws_subnet.general_stage_public_subnet_c.id}"
  route_table_id = "${aws_route_table.general_stage_public_routetable.id}"
}

resource "aws_eip" "general_stage_nat" {
  vpc = true
}

resource "aws_nat_gateway" "general_stage" {
  allocation_id = "${aws_eip.general_stage_nat.id}"
  subnet_id     = "${aws_subnet.general_stage_public_subnet_a.id}"

  tags = {
    Name = "general_stage VPC NAT"
  }
}

resource "aws_route_table" "general_stage_private_routetable" {
  vpc_id = "${aws_vpc.general_stage.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.general_stage.id}"
  }
  route {
    cidr_block = "${aws_vpc.sddp_stage.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.sddp_stage2general_stage.id}"
  }
  route {
    cidr_block = "${aws_vpc.csb_stage.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.csb_stage2general_stage.id}"
  }
  depends_on = ["aws_nat_gateway.general_stage"]

  tags = {
    label = "general_stage"
    Name  = "general_stage_private_routetable"
  }
}


resource "aws_route_table_association" "general_stage_be_subnet_a" {
  subnet_id      = "${aws_subnet.general_stage_be_subnet_a.id}"
  route_table_id = "${aws_route_table.general_stage_private_routetable.id}"
}

resource "aws_route_table_association" "general_stage_be_subnet_b" {
  subnet_id      = "${aws_subnet.general_stage_be_subnet_b.id}"
  route_table_id = "${aws_route_table.general_stage_private_routetable.id}"
}

resource "aws_route_table_association" "general_stage_be_subnet_c" {
  subnet_id      = "${aws_subnet.general_stage_be_subnet_c.id}"
  route_table_id = "${aws_route_table.general_stage_private_routetable.id}"
}

resource "aws_route_table_association" "general_stage_db_subnet_a" {
  subnet_id      = "${aws_subnet.general_stage_db_subnet_a.id}"
  route_table_id = "${aws_route_table.general_stage_private_routetable.id}"
}

resource "aws_route_table_association" "general_stage_db_subnet_b" {
  subnet_id      = "${aws_subnet.general_stage_db_subnet_b.id}"
  route_table_id = "${aws_route_table.general_stage_private_routetable.id}"
}

resource "aws_route_table_association" "general_stage_db_subnet_c" {
  subnet_id      = "${aws_subnet.general_stage_db_subnet_c.id}"
  route_table_id = "${aws_route_table.general_stage_private_routetable.id}"
}
