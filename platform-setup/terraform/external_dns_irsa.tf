module "iam_assumable_role_admin_external_dns" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "2.14.0"
  create_role                   = true
  role_name                     = "external-dns"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.external_dns.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.ED_service_account_namespace}:${local.ED_service_account_name}"]
}

resource "aws_iam_policy" "external_dns" {
  name_prefix = "external_dns"
  description = "EKS external-dns policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.external_dns.json
}

# Required permissions for external-dns
# See https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/aws.md#iam-permissions
data "aws_iam_policy_document" "external_dns" {
  statement {
    sid = "ExternalDNSUpdateDNSRecords"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = ["${var.ephemeral_hostedzone_arn}"]
  }

  statement {
    sid = "ExternalDNSViewDNSRecords"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = ["*"]
  }
}