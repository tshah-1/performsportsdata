locals {
  account_parameters = {
    account_id = data.aws_caller_identity.current.account_id
  }
}
