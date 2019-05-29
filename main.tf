provider "aws" {
  profile = "${var.profile}"
  region  = "${terraform.workspace}"
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-performsportsdata-terraform-state-lock" {
  name           = "terraform.dynamo.lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}

terraform {
  backend "s3" {
    bucket         = "sportsdata-terraform-state-v1"
    key            = "sportsdata-terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    profile        = "performsportsdata"
    dynamodb_table = "terraform.dynamo.lock"
  }
}
