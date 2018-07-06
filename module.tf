data "external" "oauth_token" {
  program = ["python", "${path.module}/scripts/"]

  query = {
    # arbitrary map from strings to strings, passed
    # to the external program as the data query.
    username = "${var.repo_user}"
  }
}

data "template_file" "module" {
  template = "${file("${path.module}/module.json.tpl")}"

  vars {
    repo_org       = "${var.github_organization}"
    repo_name      = "${var.repo}"
    oauth_token_id = "${data.external.oauth_token.result.oauth_id}"
  }
}

resource "null_resource" "parse_template" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    rendered_template = "${data.template_file.module.rendeered}"
  }

  provisioner "local-exec" {
    command = "echo ${data.template_file.module.rendeered} > /tmp/${var.repo}_module.json"
  }
}
