resource "aws_vpc_peering_connection" "csb2gearboxpeer" {
  vpc_id        = "vpc-00bd6df56bbf1e801" # CSB PROD
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
    Name        = "CSB VPC to gearbox VPC peering"
    Application = "CSB"
    Company     = "Perform"
    Side        = "requestor"
  }
}

resource "aws_vpc_peering_connection" "stagingcsb2gearboxpeer" {
  vpc_id        = "vpc-00bd6df56bbf1e801" # CSB PROD
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
    Name        = "CSB VPC to gearbox staging VPC peering"
    Application = "CSB"
    Company     = "Perform"
    Side        = "requestor"
  }
}

resource "aws_vpc_peering_connection" "csb2general" {
  vpc_id      = "vpc-00bd6df56bbf1e801" # CSB PROD
  peer_vpc_id = "vpc-0274690a550711dc1"
  auto_accept = true

  tags = {
    Name        = "csb VPC to general VPC peering"
    Application = "csb"
    Company     = "Perform"
  }
}
