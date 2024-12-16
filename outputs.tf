output "auth_role_arn" {
  value = aws_iam_role.auth_role.arn
}

output "unauth_role_arn" {
  value = aws_iam_role.unauth_role.arn
}

output "lambda_exec_role_arn" {
  value = aws_iam_role.lambda_exec_role.arn
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.identity_pool.id
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "private_subnet_id" {
  value = module.networking.private_subnet_id
}

output "security_group_id" {
  value = module.networking.security_group_id
}
