resource "aws_vpc" "es_cluster" {
  cidr_block           = "172.24.64.0/22"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "es_cluster"
  }
}

resource "aws_subnet" "es_cluster_subnet_a" {
  vpc_id                  = aws_vpc.es_cluster.id
  cidr_block              = "172.24.64.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "es_cluster_a"
    Application = "es_cluster"
    Tier        = "BE"
  }
}

resource "aws_subnet" "es_cluster_subnet_b" {
  vpc_id                  = aws_vpc.es_cluster.id
  cidr_block              = "172.24.65.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "false"

  tags = {
    Name        = "es_cluster_b"
    Application = "es_cluster"
    Tier        = "BE"
  }
}

resource "aws_subnet" "es_cluster_subnet_c" {
  vpc_id            = aws_vpc.es_cluster.id
  cidr_block        = "172.24.66.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name        = "es_cluster_c"
    Application = "es_cluster"
    Tier        = "BE"
  }
}

resource "aws_internet_gateway" "es_cluster-ig" {
  vpc_id = aws_vpc.es_cluster.id

  tags = {
    Name        = "es_cluster IG"
    Application = "es_cluster"
  }
}

resource "aws_eip" "es_cluster_nat" {
  vpc = true
}

resource "aws_nat_gateway" "es_cluster" {
  allocation_id = aws_eip.es_cluster_nat.id
  subnet_id     = aws_subnet.es_cluster_subnet_a.id

  tags = {
    Name = "es_cluster VPC NAT"
  }
}

resource "aws_route_table" "es_cluster_private_routetable" {
  vpc_id = aws_vpc.es_cluster.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.es_cluster.id
  }
  route {
    cidr_block                = "172.24.16.0/20"
    vpc_peering_connection_id = "pcx-0a38009c4dc88e7f5"
  }
  depends_on = [aws_nat_gateway.es_cluster]

  tags = {
    label = "es_cluster"
    Name  = "es_cluster_private_routetable"
  }
}


resource "aws_route_table_association" "es_cluster_subnet_a" {
  subnet_id      = aws_subnet.es_cluster_subnet_a.id
  route_table_id = aws_route_table.es_cluster_private_routetable.id
}

resource "aws_route_table_association" "es_cluster_subnet_b" {
  subnet_id      = aws_subnet.es_cluster_subnet_b.id
  route_table_id = aws_route_table.es_cluster_private_routetable.id
}

resource "aws_route_table_association" "es_cluster_subnet_c" {
  subnet_id      = aws_subnet.es_cluster_subnet_c.id
  route_table_id = aws_route_table.es_cluster_private_routetable.id
}
