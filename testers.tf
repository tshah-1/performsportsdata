resource "aws_iam_user" "maja-wloch" {
  name = "maja.wloch"
  path = "/"
}

resource "aws_iam_user" "arkadiusz-mroczek" {
  name = "arkadiusz.mroczek"
  path = "/"
}

resource "aws_iam_user" "adrian-marzec" {
  name = "adrian.marzec"
  path = "/"
}

resource "aws_iam_user" "emil-dziuba" {
  name = "emil.dziuba"
  path = "/"
}

resource "aws_iam_user" "damian-wilga" {
  name = "damian.wilga"
  path = "/"
}

resource "aws_iam_user" "lukasz-rother" {
  name = "lukasz.rother"
  path = "/"
}

#

resource "aws_iam_group" "testers" {
  name = "testers"
  path = "/"
}

#

resource "aws_iam_group_membership" "testers" {
  name  = "testers"
  group = aws_iam_group.testers.name

  users = [
    aws_iam_user.maja-wloch.name,
    aws_iam_user.arkadiusz-mroczek.name,
    aws_iam_user.adrian-marzec.name,
    aws_iam_user.emil-dziuba.name,
    aws_iam_user.damian-wilga.name,
    aws_iam_user.lukasz-rother.name,
  ]
}

#

resource "aws_iam_policy" "testers01" {
  name   = "testers01"
  policy = file("${path.module}/templates/testers01.json")
}

#

resource "aws_iam_group_policy_attachment" "testers" {
  for_each = {
    01 = aws_iam_policy.testers01.arn
  }

  group      = aws_iam_group.testers.name
  policy_arn = each.value
}

