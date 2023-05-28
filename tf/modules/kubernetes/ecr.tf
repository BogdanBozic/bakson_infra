resource "aws_ecr_repository" "bakson_app_repo" {
  name         = var.project_name
  force_delete = true
}
