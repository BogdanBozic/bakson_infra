module "bakson_project" {
  source         = "../../modules/kubernetes"
  access_key     = var.access_key
  app_name       = var.app_name
  domain         = var.domain
  email          = var.email
  github_token   = var.github_token
  project_name   = var.project_name
  secret_key     = var.secret_key
  default_region = var.default_region
}