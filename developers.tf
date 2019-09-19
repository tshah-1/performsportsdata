resource "aws_iam_user" "wiktor-walasek" {
  name = "wiktor.walasek"
  path = "/"
}

resource "aws_iam_user" "grzegorz-wakan" {
  name = "grzegorz.wakan"
  path = "/"
}

#

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/"
}

#

resource "aws_iam_group_membership" "developers" {
  name  = "developers"
  group = "${aws_iam_group.developers.name}"

  users = [
    "${aws_iam_user.wiktor-walasek.name}",
    "${aws_iam_user.grzegorz-wakan.name}"
  ]
}

#

resource "aws_iam_group_policy_attachment" "developers" {
  for_each = {
    s3          = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    ec2         = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    beanstalk   = "arn:aws:iam::aws:policy/AWSElasticBeanstalkFullAccess"
    cloudwatch  = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
    rds         = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
    elasticache = "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
    dynamo      = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    ses         = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
    route53     = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
  }

  group      = "${aws_iam_group.developers.name}"
  policy_arn = "${each.value}"
}

