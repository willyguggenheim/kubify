# Terraform self
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}


#
# IAM users
#

resource "aws_iam_user" "users" {
  name = var.users
  count               = "${var.users ? 1 : 0}"
}



#_____________________________________________

#
# IAM group + membership of group
#

resource "aws_iam_group" "user_group" {
  name = "functions-read-telemetry"
}

resource "aws_iam_group_membership" "user_group" {
  name  = "${var.group_name}-membership"
  users = var.users

  group = aws_iam_group.user_group.name
}

#
# IAM policy to allow the user group to assume the role passed to the module
#

data "aws_iam_policy_document" "assume_role_policy_doc" {
  statement {
    actions   = ["lambda:Get*", "lambda:List*", "cloudwatch:*", "logs:*"]
  }
}

resource "aws_iam_policy" "assume_role_policy" {
  name        = "assume-role-${aws_iam_group.user_group.name}"
  path        = "/"
  description = "Allows the ${aws_iam_group.user_group.name} role to be assumed."
  policy      = data.aws_iam_policy_document.assume_role_policy_doc.json
}

resource "aws_iam_group_policy_attachment" "assume_role_policy_attachment" {
  group      = aws_iam_group.user_group.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}



#_______

# 
# Roles
#

## EKS:


resource "aws_iam_role" "example" {
  name = "eks-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.example.name
}


## Lambda Functions:

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
