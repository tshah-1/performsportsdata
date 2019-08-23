resource "aws_iam_group" "admin-users" {
    name = "admin-users"
    path = "/"
}

resource "aws_iam_group" "codecommit-admin" {
    name = "codecommit-admin"
    path = "/"
}

resource "aws_iam_group" "codecommit-user" {
    name = "codecommit-user"
    path = "/"
}

resource "aws_iam_group_membership" "admin-users" {
    name  = "admin-users-group-membership"
    users = ["damian.czarnecki", "robert.hamilton", "christian.ringhofer", "volker.hutten", "harald.saringer", "bernd.dielacher", "gernot.heschl", "zsolt.biro", "karl.ferk", "tomasz.harazin", "chris.muzyunda", "bostjan.bele", "krzysztof.magosa"]
    group = "admin-users"
}

resource "aws_iam_group_membership" "codecommit-admin" {
    name  = "codecommit-admin-group-membership"
    users = ["csb-deployer"]
    group = "codecommit-admin"
}

resource "aws_iam_group_membership" "codecommit-user" {
    name  = "codecommit-user-group-membership"
    users = []
    group = "codecommit-user"
}

resource "aws_iam_group_policy" "admin-users_explicit-admin" {
    name   = "explicit-admin"
    group  = "admin-users"
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY
}


resource "aws_iam_policy_attachment" "AdministratorAccess-policy-attachment" {
    name       = "AdministratorAccess-policy-attachment"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    groups     = []
    users      = ["trishul.shah"]
    roles      = []
}

resource "aws_iam_user" "bernd-dielacher" {
    name = "bernd.dielacher"
    path = "/"
}

resource "aws_iam_user" "bostjan-bele" {
    name = "bostjan.bele"
    path = "/"
}

resource "aws_iam_user" "chris-muzyunda" {
    name = "chris.muzyunda"
    path = "/"
}

resource "aws_iam_user" "christianringhofer" {
    name = "christian.ringhofer"
    path = "/"
}

resource "aws_iam_user" "csb-deployer" {
    name = "csb-deployer"
    path = "/"
}

resource "aws_iam_user" "damian-czarnecki" {
    name = "damian.czarnecki"
    path = "/"
}

resource "aws_iam_user" "gernot-heschl" {
    name = "gernot.heschl"
    path = "/"
}

resource "aws_iam_user" "harald-saringer" {
    name = "harald.saringer"
    path = "/"
}

resource "aws_iam_user" "karl-ferk" {
    name = "karl.ferk"
    path = "/"
}

resource "aws_iam_user" "robert-hamilton" {
    name = "robert.hamilton"
    path = "/"
}

resource "aws_iam_user" "tomasz-harazin" {
    name = "tomasz.harazin"
    path = "/"
}

resource "aws_iam_user" "trishul-shah" {
    name = "trishul.shah"
    path = "/"
}

resource "aws_iam_user" "volker-hutten" {
    name = "volker.hutten"
    path = "/"
}

resource "aws_iam_user" "zsolt-biro" {
    name = "zsolt.biro"
    path = "/"
}

resource "aws_iam_user" "krzysztof-magosa" {
    name = "krzysztof.magosa"
    path = "/"
}


