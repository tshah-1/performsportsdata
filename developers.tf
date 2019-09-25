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

resource "aws_iam_policy" "developers01" {
  name   = "developers01"
  policy = "${file("${path.module}/templates/developers01.json")}"
}

resource "aws_iam_policy" "developers02" {
  name   = "developers02"
  policy = "${file("${path.module}/templates/developers02.json")}"
}

#

resource "aws_iam_group_policy_attachment" "developers" {
  for_each = {
    01 = "${aws_iam_policy.developers01.arn}"
    02 = "${aws_iam_policy.developers02.arn}"
  }

  group      = "${aws_iam_group.developers.name}"
  policy_arn = "${each.value}"
}

