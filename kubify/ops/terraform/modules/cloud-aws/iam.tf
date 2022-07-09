#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "helm_cluster_autoscaler" {
  name = "${var.cluster_name}-eks-helm-cluster-autoscaler"

  policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "autoscaling:SetDesiredCapacity",
                    "autoscaling:TerminateInstanceInAutoScalingGroup"
                ],
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled": "true",
                        "aws:ResourceTag/k8s.io/cluster-autoscaler/<my-cluster>": "owned"
                    }
                }
            },
            {
                "Effect": "Allow",
                "Action": [
                    "autoscaling:DescribeAutoScalingInstances",
                    "autoscaling:DescribeAutoScalingGroups",
                    "ec2:DescribeLaunchTemplateVersions",
                    "autoscaling:DescribeTags",
                    "autoscaling:DescribeLaunchConfigurations"
                ],
                "Resource": "*"
            }
        ]
    }
  EOF
}