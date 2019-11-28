resource "aws_vpc" "csb_stage" {
  cidr_block           = "172.29.48.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "csb_stage"
  }
}

resource "aws_subnet" "csb_stage_public_subnet_a" {
  vpc_id     = aws_vpc.csb_stage.id
  cidr_block = "172.29.48.0/24"

  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "csb_stage_fe_a"
    Application = "csb_stage"
    Tier        = "FE"
  }
}

resource "aws_subnet" "csb_stage_public_subnet_b" {
  vpc_id     = aws_vpc.csb_stage.id
  cidr_block = "172.29.49.0/24"

  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "csb_stage_fe_b"
    Application = "csb_stage"
    Tier        = "FE"
  }
}

resource "aws_subnet" "csb_stage_public_subnet_c" {
  vpc_id     = aws_vpc.csb_stage.id
  cidr_block = "172.29.50.0/24"

  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "csb_stage_fe_c"
    Application = "csb_stage"
    Tier        = "FE"
  }
}


resource "aws_subnet" "csb_stage_be_subnet_a" {
  vpc_id                  = aws_vpc.csb_stage.id
  cidr_block              = "172.29.51.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "csb_stage_be_a"
    Application = "csb_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "csb_stage_be_subnet_b" {
  vpc_id                  = aws_vpc.csb_stage.id
  cidr_block              = "172.29.52.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "csb_stage_be_b"
    Application = "csb_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "csb_stage_be_subnet_c" {
  vpc_id            = aws_vpc.csb_stage.id
  cidr_block        = "172.29.53.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name        = "csb_stage_be_c"
    Application = "csb_stage"
    Tier        = "BE"
  }
}

resource "aws_subnet" "csb_stage_db_subnet_a" {
  vpc_id            = aws_vpc.csb_stage.id
  cidr_block        = "172.29.54.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "csb_stage_db_a"
    Application = "csb_stage"
    Tier        = "DB"
  }
}

resource "aws_subnet" "csb_stage_db_subnet_b" {
  vpc_id            = aws_vpc.csb_stage.id
  cidr_block        = "172.29.55.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "csb_stage_db_b"
    Application = "csb_stage"
    Tier        = "DB"
  }
}

resource "aws_subnet" "csb_stage_db_subnet_c" {
  vpc_id            = aws_vpc.csb_stage.id
  cidr_block        = "172.29.56.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name        = "csb_stage_db_c"
    Application = "csb_stage"
    Tier        = "DB"
  }
}

resource "aws_internet_gateway" "csb_stage-ig" {
  vpc_id = aws_vpc.csb_stage.id

  tags = {
    Name        = "csb_stage IG"
    Application = "csb_stage"
  }
}

resource "aws_route_table" "csb_stage_public_routetable" {
  vpc_id = aws_vpc.csb_stage.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.csb_stage-ig.id
  }

  # route {
  #   cidr_block = "10.0.2.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.stagingcsb_stage2gearboxpeer.id
  # }

  # route {
  #   cidr_block = "10.0.3.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.stagingcsb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.64.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.stagingcsb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.11.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.12.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.13.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.14.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2gearboxpeer.id
  # }
  route {
    cidr_block                = aws_vpc.general_stage.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2general_stage.id
  }
  # route {
  #   cidr_block = "172.31.0.0/16"
  #   vpc_peering_connection_id = "pcx-07e8150d8d3556258"
  # }
  # route {
  #   cidr_block = "172.24.0.0/24"
  #   vpc_peering_connection_id = "pcx-05750b249ed659ec8"
  # }

  tags = {
    label = "csb_stage"
    Name  = "csb_stage_public_routetable"
  }
}

resource "aws_route_table_association" "csb_stage_public_subnet_a" {
  subnet_id      = aws_subnet.csb_stage_public_subnet_a.id
  route_table_id = aws_route_table.csb_stage_public_routetable.id
}

resource "aws_route_table_association" "csb_stage_public_subnet_b" {
  subnet_id      = aws_subnet.csb_stage_public_subnet_b.id
  route_table_id = aws_route_table.csb_stage_public_routetable.id
}

resource "aws_route_table_association" "csb_stage_public_subnet_c" {
  subnet_id      = aws_subnet.csb_stage_public_subnet_c.id
  route_table_id = aws_route_table.csb_stage_public_routetable.id
}

resource "aws_eip" "csb_stage_nat" {
  vpc = true
}

resource "aws_nat_gateway" "csb_stage" {
  allocation_id = aws_eip.csb_stage_nat.id
  subnet_id     = aws_subnet.csb_stage_public_subnet_a.id

  tags = {
    Name = "csb_stage VPC NAT"
  }
}

resource "aws_route_table" "csb_stage_private_routetable" {
  vpc_id = aws_vpc.csb_stage.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.csb_stage.id
  }
  # route {
  #   cidr_block = "10.0.2.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.stagingcsb_stage2gearboxpeer.id
  # }

  # route {
  #   cidr_block = "10.0.3.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.stagingcsb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.64.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.stagingcsb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.11.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.12.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.13.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2gearboxpeer.id
  # }
  # route {
  #   cidr_block = "10.0.14.0/24"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2gearboxpeer.id
  # }
  route {
    cidr_block                = aws_vpc.general_stage.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.csb_stage2general_stage.id
  }
  depends_on = [aws_nat_gateway.csb_stage]

  tags = {
    label = "csb_stage"
    Name  = "csb_stage_private_routetable"
  }
}


resource "aws_route_table_association" "csb_stage_be_subnet_a" {
  subnet_id      = aws_subnet.csb_stage_be_subnet_a.id
  route_table_id = aws_route_table.csb_stage_private_routetable.id
}

resource "aws_route_table_association" "csb_stage_be_subnet_b" {
  subnet_id      = aws_subnet.csb_stage_be_subnet_b.id
  route_table_id = aws_route_table.csb_stage_private_routetable.id
}

resource "aws_route_table_association" "csb_stage_be_subnet_c" {
  subnet_id      = aws_subnet.csb_stage_be_subnet_c.id
  route_table_id = aws_route_table.csb_stage_private_routetable.id
}

resource "aws_route_table_association" "csb_stage_db_subnet_a" {
  subnet_id      = aws_subnet.csb_stage_db_subnet_a.id
  route_table_id = aws_route_table.csb_stage_private_routetable.id
}

resource "aws_route_table_association" "csb_stage_db_subnet_b" {
  subnet_id      = aws_subnet.csb_stage_db_subnet_b.id
  route_table_id = aws_route_table.csb_stage_private_routetable.id
}

resource "aws_route_table_association" "csb_stage_db_subnet_c" {
  subnet_id      = aws_subnet.csb_stage_db_subnet_c.id
  route_table_id = aws_route_table.csb_stage_private_routetable.id
}

# resource "aws_vpc_peering_connection" "csb_stage2gearboxpeer" {
#   vpc_id        = aws_vpc.csb_stage.id
#   peer_vpc_id   = "vpc-b590e0dd"
#   peer_owner_id = "447795335313"
#   peer_region   = "eu-west-1"
#   auto_accept   = false

#   #  requester {
#   #    allow_remote_vpc_dns_resolution = true
#   #  }

#   # accepter {
#   #    allow_remote_vpc_dns_resolution = true
#   #  }

#   tags = {
#     Name        = "csb_stage VPC to gearbox VPC peering"
#     Application = "csb_stage"
#     Company     = "Perform"
#     Side        = "requestor"
#   }
# }

# resource "aws_vpc_peering_connection" "stagingcsb_stage2gearboxpeer" {
#   vpc_id        = aws_vpc.csb_stage.id
#   peer_vpc_id   = "vpc-e1691a88"
#   peer_owner_id = "447795335313"
#   peer_region   = "us-west-1"
#   auto_accept   = false

#   #  requester {
#   #    allow_remote_vpc_dns_resolution = true
#   #  }

#   # accepter {
#   #    allow_remote_vpc_dns_resolution = true
#   #  }

#   tags = {
#     Name        = "csb_stage VPC to gearbox staging VPC peering"
#     Application = "csb_stage"
#     Company     = "Perform"
#     Side        = "requestor"
#   }
# }

resource "aws_vpc_peering_connection" "csb_stage2general_stage" {
  vpc_id      = aws_vpc.csb_stage.id
  peer_vpc_id = aws_vpc.general_stage.id
  auto_accept = true

  tags = {
    Name        = "csb_stage VPC to general_stage VPC peering"
    Application = "csb_stage"
    Company     = "Perform"
  }
}
