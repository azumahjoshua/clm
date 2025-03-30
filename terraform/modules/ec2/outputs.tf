# Output the instance ID(s)
output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.this[*].id
}

# Output the public IP(s) of the instances
output "public_ips" {
  description = "List of public IP addresses of the instances"
  value       = aws_instance.this[*].public_ip
}

# Output the private IP(s) of the instances
output "private_ips" {
  description = "List of private IP addresses of the instances"
  value       = aws_instance.this[*].private_ip
}

# Output the IAM instance profile associated with the instances
output "iam_instance_profiles" {
  description = "List of IAM instance profiles associated with the instances"
  value       = aws_instance.this[*].iam_instance_profile
}

# Output the root volume ID(s)
output "root_volume_ids" {
  description = "List of root EBS volume IDs attached to the instances"
  value       = [for instance in aws_instance.this : instance.root_block_device[0].volume_id]
}

# Output the security group ID(s)
output "security_group_ids" {
  description = "List of security group IDs associated with the instances"
  value       = aws_instance.this[*].vpc_security_group_ids
}

# Output the instance ARN(s)
output "instance_arns" {
  description = "List of ARNs of the EC2 instances"
  value       = aws_instance.this[*].arn
}

# Output the availability zone(s) of the instances
output "availability_zones" {
  description = "List of availability zones where instances are launched"
  value       = aws_instance.this[*].availability_zone
}

# Output the subnet ID(s) of the instances
output "subnet_ids" {
  description = "List of subnet IDs where instances are launched"
  value       = aws_instance.this[*].subnet_id
}

# Output the key pair name(s) used for the instances
output "key_pair_names" {
  description = "List of key pair names used for the instances"
  value       = aws_instance.this[*].key_name
}

# Output the instance state(s)
output "instance_states" {
  description = "List of states of the EC2 instances"
  value       = aws_instance.this[*].instance_state
}

# Output the public DNS name(s)
output "public_dns" {
  description = "List of public DNS names of the instances"
  value       = aws_instance.this[*].public_dns
}

# Output the private DNS name(s)
output "private_dns" {
  description = "List of private DNS names of the instances"
  value       = aws_instance.this[*].private_dns
}