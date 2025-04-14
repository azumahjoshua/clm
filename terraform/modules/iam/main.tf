data "aws_caller_identity" "current" {}
resource "aws_iam_role" "github_actions_role" {
  name               = "${var.name}-github-actions-role"
  description        = "IAM role for GitHub Actions and EC2 instances"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # GitHub Actions OIDC
      {
        Effect    = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
        }
      },
      # EC2 Instance
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

# GitHub Actions ECR Push Policy
resource "aws_iam_policy" "github_actions_ecr_push" {
  name        = "${var.name}-github-actions-ecr-push"
  description = "Permissions for GitHub Actions to push to ECR Public"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ecr-public:GetAuthorizationToken",
          "ecr-public:BatchCheckLayerAvailability",
          "ecr-public:GetRepositoryPolicy",
          "ecr-public:DescribeRepositories",
          "ecr-public:DescribeImages",
          "ecr-public:BatchDeleteImage",
          "ecr-public:InitiateLayerUpload",
          "ecr-public:UploadLayerPart",
          "ecr-public:CompleteLayerUpload",
          "ecr-public:PutImage",
          "ecr-public:SetRepositoryPolicy",
          "ecr-public:CreateRepository"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "sts:GetServiceBearerToken",
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = "us-east-1"
          }
        }
      }
    ]
  })
}

# EC2 ECR Pull Policy
resource "aws_iam_policy" "ec2_ecr_pull" {
  name        = "${var.name}-ec2-ecr-pull"
  description = "Permissions for EC2 to pull from ECR Public"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ecr-public:GetAuthorizationToken",
          "ecr-public:BatchGetImage",
          "ecr-public:GetDownloadUrlForLayer"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "sts:GetServiceBearerToken",
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = "us-east-1"
          }
        }
      }
    ]
  })
}

# Attach policies to role
resource "aws_iam_role_policy_attachment" "github_actions_ecr_push" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_ecr_push.arn
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_pull" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.ec2_ecr_pull.arn
}

resource "aws_iam_instance_profile" "github_actions_profile" {
  name = "${var.name}-github-actions-profile"
  role = aws_iam_role.github_actions_role.name
  tags = var.tags
}