output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecrpublic_repository.this.repository_uri
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecrpublic_repository.this.arn
}