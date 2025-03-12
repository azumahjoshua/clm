variable "name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "clm-repo"
}

variable "description" {
  description = "Description of the repository"
  type        = string
  default     = "Public ECR repository"
}