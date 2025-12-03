output "public-ecr-name" {
  value = aws_ecrpublic_repository.kube_rca.repository_name
}

output "public-ecr-uri" {
  value = aws_ecrpublic_repository.kube_rca.repository_uri
}
