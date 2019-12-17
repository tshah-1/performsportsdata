resource "aws_vpc_peering_connection" "gearboxpeer" {
  vpc_id        = "vpc-0ad47aa6cdcf75b40"
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
    Name        = "esports VPC to gearbox VPC peering"
    Application = "esports"
    Company     = "Perform"
    Side        = "requestor"
  }
}

resource "aws_vpc_peering_connection" "sddp_prod_peer" {
  vpc_id      = "vpc-0ad47aa6cdcf75b40"
  peer_vpc_id = "vpc-0e0c8150af78b40ba"
  auto_accept = true

  tags = {
    Name        = "esports VPC to sddp VPC peering"
    Application = "esports"
    Company     = "Perform"
  }
}
