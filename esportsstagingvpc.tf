resource "aws_vpc_peering_connection" "sddp_staging_peer" {
  vpc_id      = "vpc-05b62c1e7cc938e38" # was aws_vpc.esportsstaging.id
  peer_vpc_id = "vpc-03ad24bff94e7d469"
  auto_accept = true

  tags = {
    Name        = "esportsstaging VPC to sddp_stage VPC peering"
    Application = "esports"
    Company     = "Perform"
  }
}
