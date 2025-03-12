
resource "aws_ecrpublic_repository" "this" {
  # provider        = aws.ecr-public
  repository_name = var.name

  catalog_data {
    description = var.description
  }
}
