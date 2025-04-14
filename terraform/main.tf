# 1. VPC Module
module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = "clm-vpc"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# 2. IAM Module
module "iam" {
  source      = "./modules/iam"
  name        = "clm"
  github_org  = "azumahjoshua"
  github_repo = "azumahjoshua/clm"
  tags = {
    Environment = "production"
  }
}

# 3. ALB Security Group
module "alb_sg" {
  source         = "./modules/security_group"
  sg_name        = "alb-sg"
  sg_description = "Security group for ALB allowing HTTP/HTTPS traffic"
  vpc_id         = module.vpc.vpc_id
}

# 4. App Server SG
module "app_server_sg" {
  source         = "./modules/security_group"
  sg_name        = "app-server-sg"
  sg_description = "SSH access from bastion host and internet access"
  vpc_id         = module.vpc.vpc_id
}

# 5. Jump Server SG
module "jump_server_sg" {
  source         = "./modules/security_group"
  sg_name        = "jump-server-sg"
  sg_description = "SSH access from GitHub Actions"
  vpc_id         = module.vpc.vpc_id
}

# ALB Rules
resource "aws_security_group_rule" "alb_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = module.alb_sg.security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP from internet"
}

resource "aws_security_group_rule" "alb_egress_frontend" {
  type              = "egress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  security_group_id = module.alb_sg.security_group_id
  cidr_blocks       = [module.vpc.vpc_cidr_block]
  description       = "Allow to frontend port"
}

resource "aws_security_group_rule" "alb_egress_backend" {
  type              = "egress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  security_group_id = module.alb_sg.security_group_id
  cidr_blocks       = [module.vpc.vpc_cidr_block]
  description       = "Allow to backend port"
}

# App Server Rules
resource "aws_security_group_rule" "app_ingress_frontend_from_alb" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = module.app_server_sg.security_group_id
  source_security_group_id = module.alb_sg.security_group_id
  description              = "Allow frontend access from ALB"
}

module "postgres_sg" {
  source         = "./modules/security_group"
  sg_name        = "postgres-sg"
  sg_description = "Security group for PostgreSQL database"
  vpc_id         = module.vpc.vpc_id
}

# Allow app servers to initiate connections to PostgreSQL
resource "aws_security_group_rule" "app_to_postgres" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = module.app_server_sg.security_group_id
  source_security_group_id = module.postgres_sg.security_group_id
  description              = "Allow app servers to connect to PostgreSQL"
}

# Allow PostgreSQL to receive connections from app servers
resource "aws_security_group_rule" "postgres_from_app" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = module.postgres_sg.security_group_id
  source_security_group_id = module.app_server_sg.security_group_id
  description              = "Allow PostgreSQL access from app servers"
}

resource "aws_security_group_rule" "app_ingress_backend_from_alb" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  security_group_id        = module.app_server_sg.security_group_id
  source_security_group_id = module.alb_sg.security_group_id
  description              = "Allow backend access from ALB"
}

resource "aws_security_group_rule" "app_ingress_ssh_from_jump" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.app_server_sg.security_group_id
  source_security_group_id = module.jump_server_sg.security_group_id
  description              = "Allow SSH from Jump Server"
}

resource "aws_security_group_rule" "app_ingress_deploy_from_jump" {
  type                     = "ingress"
  from_port                = 9000
  to_port                  = 9000
  protocol                 = "tcp"
  security_group_id        = module.app_server_sg.security_group_id
  source_security_group_id = module.jump_server_sg.security_group_id
  description              = "Allow CI/CD deployment port from Jump Server"
}

resource "aws_security_group_rule" "postgres_ingress_jump" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = module.postgres_sg.security_group_id
  source_security_group_id = module.jump_server_sg.security_group_id
  description              = "Emergency DB access from jump server"
}

resource "aws_security_group_rule" "app_egress_internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = module.app_server_sg.security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound to internet for package updates"
}

# Jump Server Rules
resource "aws_security_group_rule" "jump_ingress_github" {
  for_each          = local.ssh_allowed_ips
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.jump_server_sg.security_group_id
  cidr_blocks       = [each.value]
  description       = "Allow SSH from GitHub Actions and extra IPs"
}


resource "aws_security_group_rule" "jump_egress_ssh_to_app" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.jump_server_sg.security_group_id
  source_security_group_id = module.app_server_sg.security_group_id
  description              = "SSH to Docker instances"
}

resource "aws_security_group_rule" "jump_egress_internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = module.jump_server_sg.security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound to internet for updates"
}

# 6. Jump Server EC2
module "jump_server" {
  source             = "./modules/ec2"
  instance_count     = 1
  instance_name      = "jump-server"
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = "t2.micro"
  key_pair_name      = "clm_key_joshua"
  subnet_id          = module.vpc.public_subnets[0]
  security_group_ids = [module.jump_server_sg.security_group_id]
  enable_public_ip   = true
  depends_on         = [module.alb_sg]
}

# 7. App Server EC2
module "app_servers" {
  source               = "./modules/ec2"
  instance_count       = 1
  instance_name        = "app-server"
  ami_id               = data.aws_ami.ubuntu.id
  instance_type        = "t3.medium"
  key_pair_name        = "clm_key_joshua"
  subnet_id            = module.vpc.private_subnets[1]
  security_group_ids   = [module.app_server_sg.security_group_id]
  enable_public_ip     = false
  iam_instance_profile = module.iam.instance_profile_name
  depends_on           = [module.jump_server_sg]
}

# 8. ALB
module "alb" {
  source             = "./modules/alb"
  name               = "clm-alb"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  security_group_ids = [module.alb_sg.security_group_id]
  frontend_port      = 3000
  backend_port       = 8000

  tags = {
    Environment = "dev"
  }
}

# 9. ECR Repositories
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
