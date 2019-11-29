resource "aws_vpc_peering_connection" "csb_stage2general_stage" {
  vpc_id      = "vpc-022f5b303b997db6f" # it was aws_vpc.csb_stage.id
  peer_vpc_id = "vpc-0d4024983f55e5b9d" # it was aws_vpc.general_stage.id
  auto_accept = true

  tags = {
    Name        = "csb_stage VPC to general_stage VPC peering"
    Application = "csb_stage"
    Company     = "Perform"
  }
}
