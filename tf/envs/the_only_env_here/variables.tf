variable "access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "default_region" {
  type        = string
  description = "Default region for AWS resources."
}

variable "app_name" {
  type        = string
  description = "Application name."
}

variable "project_name" {
  type        = string
  description = "Project name."
}

variable "email" {
  type        = string
  description = "Email that will be used for signing certificates."
}

variable "github_token" {
  type        = string
  description = "GitHub Token that will be used to publish secrets to GitHub Actions."
}

variable "domain" {
  type        = string
  description = "Domain that you have previously purchased with AWS Route 53."
}