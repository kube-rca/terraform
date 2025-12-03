resource "aws_ecrpublic_repository" "kube_rca" {
  provider        = aws.us_east_1
  repository_name = "kube-rca-ecr"
  force_destroy   = false
}
