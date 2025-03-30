resource "aws_iam_role" "jenkins" {
  name = "${var.name}-iam-role"  

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ecr_access" {
  name        = "${var.name}-ECRAccess"  
  description = "Allows ${var.name} to interact with ECR"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_attach" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.ecr_access.arn
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "${var.name}-instance-profile"  
  role = aws_iam_role.jenkins.name
}
