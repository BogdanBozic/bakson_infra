resource "github_actions_secret" "ecr_user_access_key" {
  repository      = data.github_repository.github_app_repo.name
  secret_name     = "ECR_USER_ACCESS_KEY"
  plaintext_value = aws_iam_access_key.ecr_user_access_key.id
}

resource "github_actions_secret" "ecr_user_secret_key" {
  repository      = data.github_repository.github_app_repo.name
  secret_name     = "ECR_USER_SECRET_KEY"
  plaintext_value = aws_iam_access_key.ecr_user_access_key.secret
}

resource "github_actions_secret" "default_aws_region" {
  repository      = data.github_repository.github_app_repo.name
  secret_name     = "DEFAULT_AWS_REGION"
  plaintext_value = var.default_region
}

resource "github_actions_secret" "ecr_url" {
  repository      = data.github_repository.github_app_repo.name
  secret_name     = "ECR_URL"
  plaintext_value = aws_ecr_repository.bakson_app_repo.repository_url
}

resource "github_actions_secret" "github_token" {
  repository      = data.github_repository.github_app_repo.name
  secret_name     = "DEPLOYMENT_TOKEN"
  plaintext_value = var.github_token
}

resource "github_actions_secret" "login_github" {
  repository      = data.github_repository.github_app_repo.name
  secret_name     = "LOGIN_GITHUB"
  plaintext_value = data.github_user.current.login
}

resource "github_actions_secret" "application_name" {
  repository      = data.github_repository.github_app_repo.name
  secret_name     = "APPLICATION_NAME"
  plaintext_value = var.app_name
}