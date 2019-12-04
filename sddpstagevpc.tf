resource "aws_vpc_peering_connection" "sddp_stage2general_stage" {
  vpc_id      = "vpc-03ad24bff94e7d469"
  peer_vpc_id = "vpc-0d4024983f55e5b9d" # it was aws_vpc.general_stage.id
  auto_accept = true

  tags = {
    Name        = "sddp_stage VPC to general_stage VPC peering"
    Application = "sddp_stage"
    Company     = "Perform"
  }
}
