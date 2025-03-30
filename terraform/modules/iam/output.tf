output "jenkins_profile_name" {
  description = "The name of the Jenkins instance profile"
  value       = aws_iam_instance_profile.jenkins_profile.name
}

output "jenkins_profile_arn" {
  description = "The ARN of the Jenkins instance profile"
  value       = aws_iam_instance_profile.jenkins_profile.arn
}

output "jenkins_role_name" {
  description = "The name of the Jenkins IAM role"
  value       = aws_iam_role.jenkins.name
}