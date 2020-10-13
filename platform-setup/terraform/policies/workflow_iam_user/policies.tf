#
# Policy for github actions workflow deployment user
# Gives access to 
# 1. Ephemeral EKS cluster
# 2. route53
#

variable "ephemeral_cluster_arn" {
  type = string
}

variable "ephemeral_hostedzone_arn" {
  type = string
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid = "EksListCluster"

    actions = [
      "eks:ListClusters",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "EksReadOnly"

    actions = [
      "eks:DescribeCluster",
    ]

    resources = [
      var.ephemeral_cluster_arn,
    ]
  }

  statement {
    sid = "Route53access"

    actions = [
      "route53:ListResourceRecordSets",
    ]

    resources = [
      var.ephemeral_hostedzone_arn,
    ]
  }
}

output "policy" {
  value = data.aws_iam_policy_document.policy.json
}

