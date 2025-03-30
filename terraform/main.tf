# VPC Module
module "vpc" {
  source              = "./modules/vpc"
  vpc_name           = "jenkins-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"] 
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# IAM Module for Jenkins
module "iam" {
  source = "./modules/iam"
}

# Security Group Module for Jenkins
module "jenkins_sg" {
  source        = "./modules/security_group"
  sg_name       = "jenkins-sg"
  sg_description = "Security group for Jenkins server"
  vpc_id        = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "HTTP for Jenkins web interface"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Jenkins agent communication"
      from_port   = 50000
      to_port     = 50000
      protocol    = "tcp"
      self        = true
    }
  ]

  tags = {
    Environment = "production"
    Application = "jenkins"
  }
}

# EC2 Module for Jenkins Server
module "jenkins_server" {
  source               = "./modules/ec2"
  instance_count       = 1
  instance_name        = "jenkins-server"
  ami_id               = "ami-005fc0f236362e99f" 
  instance_type        = "t2.medium"             
  key_pair_name        = "clm_key_joshua"
  subnet_id            = module.vpc.public_subnets[0]
  security_group_id    = module.jenkins_sg.security_group_id
  enable_public_ip     = true
  iam_instance_profile = module.iam.jenkins_profile_name

  root_block_device = [{
    volume_size           = 10                   
    volume_type           = "gp2"
    delete_on_termination = true
  }]

  tags = {
    Name        = "jenkins-server"
    Role        = "jenkins"                    
    Environment = "production"
    Application = "jenkins"
    Terraform   = "true"
    Ansible     = "true"
  }
}

# ECR Modules
module "backend_ecr" {
  source      = "./modules/ecr"
  name        = "laravel-backend"
  description = "ECR repo for Laravel backend"

  providers = {
    aws.ecr-public = aws.ecr-public 
  }
}

module "frontend_ecr" {
  source      = "./modules/ecr"
  name        = "nextjs-frontend"
  description = "ECR repo for Next.js frontend"

  providers = {
    aws.ecr-public = aws.ecr-public 
  }
}