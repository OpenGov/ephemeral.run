module "ephemeral_workflow_user_policy" {
  source                   = "./policies/workflow_iam_user"
  ephemeral_cluster_arn    = module.eks.cluster_arn
  ephemeral_hostedzone_arn = var.ephemeral_hostedzone_arn
}

locals {
  tags = merge(
    {
      "service"   = "ephemeral-environments"
      "terraform" = "true"
    },
    var.tags,
  )
}

resource "aws_iam_user" "ephemeral_workflow" {
  name = "ephemeral-gha-user"
  tags = local.tags
}

resource "aws_iam_access_key" "ephemeral_workflow" {
  user = aws_iam_user.ephemeral_workflow.name
}

resource "aws_iam_policy" "ephemeral_workflow" {
  name_prefix = "ephemeral-workflow-"
  policy      = module.ephemeral_workflow_user_policy.policy
}

resource "aws_iam_user_policy_attachment" "ephemeral_workflow" {
  user       = aws_iam_user.ephemeral_workflow.name
  policy_arn = aws_iam_policy.ephemeral_workflow.arn
}
