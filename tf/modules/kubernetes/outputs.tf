output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "ecr_url" {
  value = aws_ecr_repository.bakson_app_repo.repository_url
}

output "ecr_user_access_key" {
  value = aws_iam_access_key.ecr_user_access_key.id
}

output "ecr_user_secret_key" {
  value = aws_iam_access_key.ecr_user_access_key.secret
}
