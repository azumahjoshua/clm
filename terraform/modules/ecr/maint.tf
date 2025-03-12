
resource "aws_ecrpublic_repository" "this" {
  # provider        = aws.ecr-public
  repository_name = var.name

  catalog_data {
    description = var.description
  }

  # Enable on-push vulnerability scanning
  image_scanning_configuration {
    scan_on_push = true
  }
}
