resource "aws_vpc" "esports" {
  cidr_block           = "172.24.16.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "esports"
  }
}

resource "aws_subnet" "esports_public_subnet_a" {
  vpc_id     = "${aws_vpc.esports.id}"
  cidr_block = "172.24.16.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "esports_fe_a"
    Application = "esports"
    Tier        = "FE"
  }
}

resource "aws_subnet" "esports_public_subnet_b" {
  vpc_id     = "${aws_vpc.esports.id}"
  cidr_block = "172.24.17.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "esports_fe_b"
    Application = "esports"
    Tier        = "FE"
  }
}

resource "aws_subnet" "esports_public_subnet_c" {
  vpc_id     = "${aws_vpc.esports.id}"
  cidr_block = "172.24.18.0/24"

  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = "true"

  tags {
    Name        = "esports_fe_c"
    Application = "esports"
    Tier        = "FE"
  }
}


resource "aws_subnet" "esports_be_subnet_a" {
  vpc_id                  = "${aws_vpc.esports.id}"
  cidr_block              = "172.24.19.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"

  tags {
    Name        = "esports_be_a"
    Application = "esports"
    Tier        = "BE"
  }
}

resource "aws_subnet" "esports_be_subnet_b" {
  vpc_id                  = "${aws_vpc.esports.id}"
  cidr_block              = "172.24.20.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"

  tags {
    Name        = "esports_be_b"
    Application = "esports"
    Tier        = "BE"
  }
}

resource "aws_subnet" "esports_be_subnet_c" {
  vpc_id            = "${aws_vpc.esports.id}"
  cidr_block        = "172.24.21.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "esports_be_c"
    Application = "esports"
    Tier = "BE"
  }
}

resource "aws_subnet" "esports_db_subnet_a" {
  vpc_id            = "${aws_vpc.esports.id}"
  cidr_block        = "172.24.22.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name        = "esports_db_a"
    Application = "esports"
    Tier = "DB"
  }
}

resource "aws_subnet" "esports_db_subnet_b" {
  vpc_id            = "${aws_vpc.esports.id}"
  cidr_block        = "172.24.23.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name        = "esports_db_b"
    Application = "esports"
    Tier = "DB"
  }
}

resource "aws_subnet" "esports_db_subnet_c" {
  vpc_id            = "${aws_vpc.esports.id}"
  cidr_block        = "172.24.24.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name        = "esports_db_c"
    Application = "esports"
    Tier = "DB"
  }
}

resource "aws_internet_gateway" "esports-ig" {
  vpc_id = "${aws_vpc.esports.id}"

  tags {
    Name        = "esports IG"
    Application = "esports"
  }
}

resource "aws_route_table" "esports_public_routetable" {
  vpc_id = "${aws_vpc.esports.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.esports-ig.id}"
  }

  tags {
    label = "esports"
    Name = "esports_public_routetable"
  }
}

resource "aws_route_table_association" "esports_public_subnet_a" {
  subnet_id      = "${aws_subnet.esports_public_subnet_a.id}"
  route_table_id = "${aws_route_table.esports_public_routetable.id}"
}

resource "aws_route_table_association" "esports_public_subnet_b" {
  subnet_id      = "${aws_subnet.esports_public_subnet_b.id}"
  route_table_id = "${aws_route_table.esports_public_routetable.id}"
}

resource "aws_route_table_association" "esports_public_subnet_c" {
  subnet_id      = "${aws_subnet.esports_public_subnet_c.id}"
  route_table_id = "${aws_route_table.esports_public_routetable.id}"
}

resource "aws_eip" "esports_nat" {
  vpc = true
}

resource "aws_nat_gateway" "esports" {
  allocation_id = "${aws_eip.esports_nat.id}"
  subnet_id     = "${aws_subnet.esports_public_subnet_a.id}"

  tags {
    Name = "esports VPC NAT"
  }
}

resource "aws_route_table" "esports_private_routetable" {
  vpc_id = "${aws_vpc.esports.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.esports.id}"
  }
  depends_on = ["aws_nat_gateway.esports"]

  tags {
    label = "esports"
    Name = "esports_private_routetable"
  }
}


resource "aws_route_table_association" "esports_be_subnet_a" {
  subnet_id      = "${aws_subnet.esports_be_subnet_a.id}"
  route_table_id = "${aws_route_table.esports_private_routetable.id}"
}

resource "aws_route_table_association" "esports_be_subnet_b" {
  subnet_id      = "${aws_subnet.esports_be_subnet_b.id}"
  route_table_id = "${aws_route_table.esports_private_routetable.id}"
}

resource "aws_route_table_association" "esports_be_subnet_c" {
  subnet_id      = "${aws_subnet.esports_be_subnet_c.id}"
  route_table_id = "${aws_route_table.esports_private_routetable.id}"
}

resource "aws_route_table_association" "esports_db_subnet_a" {
  subnet_id      = "${aws_subnet.esports_db_subnet_a.id}"
  route_table_id = "${aws_route_table.esports_private_routetable.id}"
}

resource "aws_route_table_association" "esports_db_subnet_b" {
  subnet_id      = "${aws_subnet.esports_db_subnet_b.id}"
  route_table_id = "${aws_route_table.esports_private_routetable.id}"
}

resource "aws_route_table_association" "esports_db_subnet_c" {
  subnet_id      = "${aws_subnet.esports_db_subnet_c.id}"
  route_table_id = "${aws_route_table.esports_private_routetable.id}"
}

resource "aws_vpc_peering_connection" "gearboxpeer" {
  vpc_id        = "${aws_vpc.esports.id}"
  peer_vpc_id   = "vpc-b590e0dd"
  peer_owner_id = "447795335313"
  peer_region   = "eu-west-1"
  auto_accept   = false

  requester {
    allow_remote_vpc_dns_resolution = true
  }

 accepter {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "esports VPC to gearbox VPC peering"
    Application = "esports"
    Company = "Perform"
    Side = "requestor"
  }
}

resource "aws_route" "esports2gearbox" {
  route_table_id = "${aws_route_table.esports_private_routetable.id}"
  destination_cidr_block = "10.0.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.gearboxpeer.id}"

}

resource "aws_route" "esportspublic2gearbox" {
  route_table_id = "${aws_route_table.esports_public_routetable.id}"
  destination_cidr_block = "10.0.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.gearboxpeer.id}"

}

resource "aws_route" "esportsp2escluster" {
  route_table_id = "${aws_route_table.esports_public_routetable.id}"
  destination_cidr_block = "172.24.64.0/22"
  vpc_peering_connection_id = "pcx-0a38009c4dc88e7f5"

}
