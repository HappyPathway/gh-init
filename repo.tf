variable "github_token" {}
variable "github_organization" {}
variable "repo" {}
variable "description" {}
variable "private" {}

variable "enable" {
  default     = "false"
  type        = "string"
  description = "Only enable if using a Github repo"
}

provider "github" {
  token        = "${var.github_token}"
  organization = "${var.github_organization}"
}

resource "github_repository" "repo" {
  count              = "${var.enable == "true" ? 1 : 0}"
  name               = "${var.repo}"
  description        = "${var.description}"
  private            = "${var.private}"
  gitignore_template = "Terraform"
}

output "git_clone_url" {
  value = "${module.repo.git_clone_url}"
}
