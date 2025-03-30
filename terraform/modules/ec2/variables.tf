variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of the key pair to use"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID to attach"
  type        = string
}

variable "enable_public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "IAM instance profile name to attach"
  type        = string
  default     = ""
}

variable "root_block_device" {
  description = "Root block device configuration"
  type = list(object({
    volume_size           = number
    volume_type           = string
    delete_on_termination = bool
  }))
  default = [{
    volume_size           = 10
    volume_type           = "gp2"
    delete_on_termination = true
  }]
}

variable "tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}