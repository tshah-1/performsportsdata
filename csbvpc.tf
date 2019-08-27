resource "aws_vpc" "csb" {
  cidr_block           = "172.24.32.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "csb"
  }
}

resource "aws_subnet" "csb_public_subnet_a" {
  vpc_id     = "${aws_vpc.csb.id}"
  cidr_block = "172.24.32.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "csb_fe_a"
    Application = "csb"
    Tier        = "FE"
  }
}

resource "aws_subnet" "csb_public_subnet_b" {
  vpc_id     = "${aws_vpc.csb.id}"
  cidr_block = "172.24.33.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "csb_fe_b"
    Application = "csb"
    Tier        = "FE"
  }
}

resource "aws_subnet" "csb_public_subnet_c" {
  vpc_id     = "${aws_vpc.csb.id}"
  cidr_block = "172.24.34.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = "true"

  tags = {
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

  tags = {
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

  tags = {
    Name        = "csb_be_b"
    Application = "csb"
    Tier        = "BE"
  }
}

resource "aws_subnet" "csb_be_subnet_c" {
  vpc_id            = "${aws_vpc.csb.id}"
  cidr_block        = "172.24.37.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "csb_be_c"
    Application = "csb"
    Tier = "BE"
  }
}

resource "aws_subnet" "csb_db_subnet_a" {
  vpc_id            = "${aws_vpc.csb.id}"
  cidr_block        = "172.24.38.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name        = "csb_db_a"
    Application = "csb"
    Tier = "DB"
  }
}

resource "aws_subnet" "csb_db_subnet_b" {
  vpc_id            = "${aws_vpc.csb.id}"
  cidr_block        = "172.24.39.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name        = "csb_db_b"
    Application = "csb"
    Tier = "DB"
  }
}

resource "aws_subnet" "csb_db_subnet_c" {
  vpc_id            = "${aws_vpc.csb.id}"
  cidr_block        = "172.24.40.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name        = "csb_db_c"
    Application = "csb"
    Tier = "DB"
  }
}

resource "aws_internet_gateway" "csb-ig" {
  vpc_id = "${aws_vpc.csb.id}"

  tags = {
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

  route {
    cidr_block = "10.0.2.0/24"
    gateway_id = "${aws_vpc_peering_connection.stagingcsb2gearboxpeer.id}"
  }

  route {
    cidr_block = "10.0.3.0/24"
    gateway_id = "${aws_vpc_peering_connection.stagingcsb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.64.0/24"
    gateway_id = "${aws_vpc_peering_connection.stagingcsb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.11.0/24"
    gateway_id = "${aws_vpc_peering_connection.csb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.12.0/24"
    gateway_id = "${aws_vpc_peering_connection.csb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.13.0/24"
    gateway_id = "${aws_vpc_peering_connection.csb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.14.0/24"
    gateway_id = "${aws_vpc_peering_connection.csb2gearboxpeer.id}"
  }
  route {
    cidr_block = "${aws_vpc.general.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.csb2general.id}"
  }
  route {
    cidr_block = "172.31.0.0/16"
    gateway_id = "pcx-07e8150d8d3556258"
  }
  route {
    cidr_block = "172.24.0.0/24"
    gateway_id = "pcx-05750b249ed659ec8"
  }

  tags = {
    label = "csb"
    Name = "csb_public_routetable"
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

  tags = {
    Name = "csb VPC NAT"
  }
}

resource "aws_route_table" "csb_private_routetable" {
  vpc_id = "${aws_vpc.csb.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.csb.id}"
  }
  route {
    cidr_block = "10.0.2.0/24"
    gateway_id = "${aws_vpc_peering_connection.stagingcsb2gearboxpeer.id}"
  }

  route {
    cidr_block = "10.0.3.0/24"
    gateway_id = "${aws_vpc_peering_connection.stagingcsb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.64.0/24"
    gateway_id = "${aws_vpc_peering_connection.stagingcsb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.11.0/24"
    gateway_id = "${aws_vpc_peering_connection.csb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.12.0/24"
    gateway_id = "${aws_vpc_peering_connection.csb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.13.0/24"
    gateway_id = "${aws_vpc_peering_connection.csb2gearboxpeer.id}"
  }
  route {
    cidr_block = "10.0.14.0/24"
    gateway_id = "${aws_vpc_peering_connection.csb2gearboxpeer.id}"
  }
  route {
    cidr_block = "${aws_vpc.general.cidr_block}"
    gateway_id = "${aws_vpc_peering_connection.csb2general.id}"
  }
  depends_on = ["aws_nat_gateway.csb"]

  tags = {
    label = "csb"
    Name = "csb_private_routetable"
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

resource "aws_vpc_peering_connection" "csb2gearboxpeer" {
  vpc_id        = "${aws_vpc.csb.id}"
  peer_vpc_id   = "vpc-b590e0dd"
  peer_owner_id = "447795335313"
  peer_region   = "eu-west-1"
  auto_accept   = false

#  requester {
#    allow_remote_vpc_dns_resolution = true
#  }

# accepter {
#    allow_remote_vpc_dns_resolution = true
#  }

  tags = {
    Name = "CSB VPC to gearbox VPC peering"
    Application = "CSB"
    Company = "Perform"
    Side = "requestor"
  }
}

resource "aws_vpc_peering_connection" "stagingcsb2gearboxpeer" {
  vpc_id        = "${aws_vpc.csb.id}"
  peer_vpc_id   = "vpc-e1691a88"
  peer_owner_id = "447795335313"
  peer_region   = "us-west-1"
  auto_accept   = false

#  requester {
#    allow_remote_vpc_dns_resolution = true
#  }

# accepter {
#    allow_remote_vpc_dns_resolution = true
#  }

  tags = {
    Name = "CSB VPC to gearbox staging VPC peering"
    Application = "CSB"
    Company = "Perform"
    Side = "requestor"
  }
}

resource "aws_vpc_peering_connection" "csb2general" {
  vpc_id      = "${aws_vpc.csb.id}"
  peer_vpc_id = "${aws_vpc.general.id}"
  auto_accept = true

  tags = {
    Name        = "csb VPC to general VPC peering"
    Application = "csb"
    Company     = "Perform"
  }
}
