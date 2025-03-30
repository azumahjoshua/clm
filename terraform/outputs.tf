output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = module.jenkins_server.instance_ids[0]
}
