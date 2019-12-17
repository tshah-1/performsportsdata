resource "aws_vpc" "optacore_prod" {
  cidr_block           = "172.24.112.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "optacore_prod"
  }
}

resource "aws_subnet" "optacore_prod_public_subnet_a" {
  vpc_id     = aws_vpc.optacore_prod.id
  cidr_block = "172.24.112.0/24"

  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "optacore_prod_fe_a"
    Application = "optacore_prod"
    Tier        = "FE"
  }
}

resource "aws_subnet" "optacore_prod_public_subnet_b" {
  vpc_id     = aws_vpc.optacore_prod.id
  cidr_block = "172.24.113.0/24"

  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "optacore_prod_fe_b"
    Application = "optacore_prod"
    Tier        = "FE"
  }
}

resource "aws_subnet" "optacore_prod_public_subnet_c" {
  vpc_id     = aws_vpc.optacore_prod.id
  cidr_block = "172.24.114.0/24"

  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "optacore_prod_fe_c"
    Application = "optacore_prod"
    Tier        = "FE"
  }
}


resource "aws_subnet" "optacore_prod_be_subnet_a" {
  vpc_id                  = aws_vpc.optacore_prod.id
  cidr_block              = "172.24.115.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "optacore_prod_be_a"
    Application = "optacore_prod"
    Tier        = "BE"
  }
}

resource "aws_subnet" "optacore_prod_be_subnet_b" {
  vpc_id                  = aws_vpc.optacore_prod.id
  cidr_block              = "172.24.116.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "optacore_prod_be_b"
    Application = "optacore_prod"
    Tier        = "BE"
  }
}

resource "aws_subnet" "optacore_prod_be_subnet_c" {
  vpc_id            = aws_vpc.optacore_prod.id
  cidr_block        = "172.24.117.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name        = "optacore_prod_be_c"
    Application = "optacore_prod"
    Tier        = "BE"
  }
}

resource "aws_subnet" "optacore_prod_db_subnet_a" {
  vpc_id            = aws_vpc.optacore_prod.id
  cidr_block        = "172.24.118.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "optacore_prod_db_a"
    Application = "optacore_prod"
    Tier        = "DB"
  }
}

resource "aws_subnet" "optacore_prod_db_subnet_b" {
  vpc_id            = aws_vpc.optacore_prod.id
  cidr_block        = "172.24.119.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "optacore_prod_db_b"
    Application = "optacore_prod"
    Tier        = "DB"
  }
}

resource "aws_subnet" "optacore_prod_db_subnet_c" {
  vpc_id            = aws_vpc.optacore_prod.id
  cidr_block        = "172.24.120.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name        = "optacore_prod_db_c"
    Application = "optacore_prod"
    Tier        = "DB"
  }
}

resource "aws_internet_gateway" "optacore_prod-ig" {
  vpc_id = aws_vpc.optacore_prod.id

  tags = {
    Name        = "optacore_prod IG"
    Application = "optacore_prod"
  }
}

resource "aws_route_table" "optacore_prod_public_routetable" {
  vpc_id = aws_vpc.optacore_prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.optacore_prod-ig.id
  }
}

resource "aws_route_table_association" "optacore_prod_public_subnet_a" {
  subnet_id      = aws_subnet.optacore_prod_public_subnet_a.id
  route_table_id = aws_route_table.optacore_prod_public_routetable.id
}

resource "aws_route_table_association" "optacore_prod_public_subnet_b" {
  subnet_id      = aws_subnet.optacore_prod_public_subnet_b.id
  route_table_id = aws_route_table.optacore_prod_public_routetable.id
}

resource "aws_route_table_association" "optacore_prod_public_subnet_c" {
  subnet_id      = aws_subnet.optacore_prod_public_subnet_c.id
  route_table_id = aws_route_table.optacore_prod_public_routetable.id
}

resource "aws_eip" "optacore_prod_nat" {
  vpc = true
}

resource "aws_nat_gateway" "optacore_prod" {
  allocation_id = aws_eip.optacore_prod_nat.id
  subnet_id     = aws_subnet.optacore_prod_public_subnet_a.id

  tags = {
    Name = "optacore_prod VPC NAT"
  }
}

resource "aws_route_table" "optacore_prod_private_routetable" {
  vpc_id = aws_vpc.optacore_prod.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.optacore_prod.id
  }
  route {
    cidr_block                = "172.24.80.0/20"
    vpc_peering_connection_id = aws_vpc_peering_connection.optacore_prod2general.id
  }
  depends_on = [aws_nat_gateway.optacore_prod]

  tags = {
    label = "optacore_prod"
    Name  = "optacore_prod_private_routetable"
  }
}


resource "aws_route_table_association" "optacore_prod_be_subnet_a" {
  subnet_id      = aws_subnet.optacore_prod_be_subnet_a.id
  route_table_id = aws_route_table.optacore_prod_private_routetable.id
}

resource "aws_route_table_association" "optacore_prod_be_subnet_b" {
  subnet_id      = aws_subnet.optacore_prod_be_subnet_b.id
  route_table_id = aws_route_table.optacore_prod_private_routetable.id
}

resource "aws_route_table_association" "optacore_prod_be_subnet_c" {
  subnet_id      = aws_subnet.optacore_prod_be_subnet_c.id
  route_table_id = aws_route_table.optacore_prod_private_routetable.id
}

resource "aws_route_table_association" "optacore_prod_db_subnet_a" {
  subnet_id      = aws_subnet.optacore_prod_db_subnet_a.id
  route_table_id = aws_route_table.optacore_prod_private_routetable.id
}

resource "aws_route_table_association" "optacore_prod_db_subnet_b" {
  subnet_id      = aws_subnet.optacore_prod_db_subnet_b.id
  route_table_id = aws_route_table.optacore_prod_private_routetable.id
}

resource "aws_route_table_association" "optacore_prod_db_subnet_c" {
  subnet_id      = aws_subnet.optacore_prod_db_subnet_c.id
  route_table_id = aws_route_table.optacore_prod_private_routetable.id
}

resource "aws_vpc_peering_connection" "optacore_prod2general" {
  vpc_id      = aws_vpc.optacore_prod.id
  peer_vpc_id = "vpc-0274690a550711dc1"
  auto_accept = true

  tags = {
    Name        = "optacore_prod VPC to general VPC peering"
    Application = "optacore_prod"
    Company     = "Perform"
  }
}
