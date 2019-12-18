resource "aws_vpc_peering_connection" "optacore_prod2general" {
  vpc_id      = "vpc-0548054043f3a866a"
  peer_vpc_id = "vpc-0274690a550711dc1"
  auto_accept = true

  tags = {
    Name        = "optacore_prod VPC to general VPC peering"
    Application = "optacore_prod"
    Company     = "Perform"
  }
}
