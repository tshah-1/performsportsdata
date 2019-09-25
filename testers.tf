resource "aws_iam_user" "maja-wloch" {
  name = "maja.wloch"
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
  group = "${aws_iam_group.testers.name}"

  users = [
    "${aws_iam_user.maja-wloch.name}",
  ]
}

#

resource "aws_iam_policy" "testers01" {
  name   = "testers01"
  policy = "${file("${path.module}/templates/testers01.json")}"
}

#

resource "aws_iam_group_policy_attachment" "testers" {
  for_each = {
    01 = "${aws_iam_policy.testers01.arn}"
  }

  group      = "${aws_iam_group.testers.name}"
  policy_arn = "${each.value}"
}

