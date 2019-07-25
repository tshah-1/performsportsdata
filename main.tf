provider "aws" {
  profile = "${var.profile}"
  region  = "${terraform.workspace}"
}

data "aws_availability_zones" "available" {}

# create a dynamodb table for locking the state file
#resource "aws_dynamodb_table" "dynamodb-performsportsdata-terraform-state-lock" {
#  name           = "terraform.performsportsdata.dynamo.lock"
#  hash_key       = "LockID"
#  read_capacity  = 20
#  write_capacity = 20
#
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#
#  tags {
#    Name = "DynamoDB Terraform State Lock Table"
#  }
#}

terraform {
  backend "s3" {
    bucket         = "terraform-state-v1"
    key            = "performsportsdata-terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    profile        = "perform-content-master"
    dynamodb_table = "terraform.performsportsdata.dynamo.lock"
  }
}
