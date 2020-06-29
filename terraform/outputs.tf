output "ecr_registry_url" {
  value = data.terraform_remote_state.aws.outputs.ecr_registry_url
}

output "ecr_repository_name" {
  value = data.terraform_remote_state.aws.outputs.ecr_repository_name
}
