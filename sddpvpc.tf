resource "aws_vpc_peering_connection" "sddp2general" {
  vpc_id      = "vpc-0e0c8150af78b40ba"
  peer_vpc_id = aws_vpc.general.id
  auto_accept = true

  tags = {
    Name        = "sddp VPC to general VPC peering"
    Application = "sddp"
    Company     = "Perform"
  }
}
