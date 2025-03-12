module "backend_ecr" {
  source      = "./modules/ecr"
  name        = "laravel-backend"
  description = "ECR repo for Laravel backend"

  providers = {
    aws = aws 
    aws.ecr-public = aws.ecr-public 
  }
}

module "frontend_ecr" {
  source      = "./modules/ecr"
  name        = "nextjs-frontend"
  description = "ECR repo for Next.js frontend"

  providers = {
    aws = aws 
    aws.ecr-public = aws.ecr-public 
  }
}
