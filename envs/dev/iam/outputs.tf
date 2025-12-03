output "group_name" {
  value = aws_iam_group.kube_rca_user_group.name
}

output "group_arn" {
  value = aws_iam_group.kube_rca_user_group.arn
}

output "group_users" {
  value = sort([for user in aws_iam_user.users : user.name])
}

output "force_mfa_policy_arn" {
  value = aws_iam_policy.force_mfa.arn
}

output "github_actions_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github_actions.arn
}

output "github_actions_oidc_role_name" {
  value = aws_iam_role.github_actions_oidc.name
}

output "github_actions_oidc_role_arn" {
  value = aws_iam_role.github_actions_oidc.arn
}

output "github_actions_ecr_push_policy_arn" {
  value = aws_iam_policy.github_actions_ecr_push.arn
}
