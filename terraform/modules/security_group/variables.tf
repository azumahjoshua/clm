variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules with optional parameters"
  type = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids = optional(list(string))
    security_groups = optional(list(string))
    self            = optional(bool)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules with optional parameters"
  type = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids = optional(list(string))
    security_groups = optional(list(string))
    self            = optional(bool)
  }))
  default = [{
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "tags" {
  description = "A map of tags to assign to the security group"
  type        = map(string)
  default     = {}
}