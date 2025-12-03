locals {
  github_org                 = "kube-rca"
  github_oidc_role_name      = "kube-rca-github-actions-oidc-role"
  github_oidc_provider_url   = "https://token.actions.githubusercontent.com"
  github_oidc_audience       = "sts.amazonaws.com"
  github_oidc_thumbprint_sha = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url = local.github_oidc_provider_url

  client_id_list = [
    local.github_oidc_audience,
  ]

  thumbprint_list = [
    local.github_oidc_thumbprint_sha,
  ]
}

resource "aws_iam_role" "github_actions_oidc" {
  name        = local.github_oidc_role_name
  description = "GitHub Actions OIDC role for pushing images to ECR"
  assume_role_policy = templatefile("${path.module}/template/github_actions_oidc_trust.json", {
    oidc_provider_arn = aws_iam_openid_connect_provider.github_actions.arn
    audience          = local.github_oidc_audience
    org               = local.github_org
  })
  max_session_duration = 3600
}

resource "aws_iam_policy" "github_actions_ecr_push" {
  name        = "kube-rca-github-actions-ecr-push"
  description = "Allow GitHub Actions to push images to account ECR repositories"
  policy = templatefile("${path.module}/template/github_actions_ecr_push.json", {
    partition  = data.aws_partition.current.partition
    region     = var.aws_region
    account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr_push" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = aws_iam_policy.github_actions_ecr_push.arn
}
