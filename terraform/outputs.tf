
output "region" {
  value = data.aws_region.current.name
}

output "jump_server_public_ip" {
  description = "Public IP of the jump server"
  value       = module.jump_server.public_ips[0] # For single instance
}

output "app_server_private_ip" {
  description = "Private IP of the app server"
  value       = module.app_servers.private_ips[0] # For single instance
}

output "alb_dns_name" {
  description = "The DNS name of the application load balancer"
  value       = module.alb.alb_dns_name
}