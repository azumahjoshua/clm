pipeline {
    agent any
    // environment {
    //     AWS_REGION = 'us-east-1'  // Change to your AWS region
    //     ECR_REPO_BACKEND = 'your-backend-repo' // Change to your ECR repo name
    //     ECR_REPO_FRONTEND = 'your-frontend-repo' // Change to your ECR repo name
    //     AWS_ACCOUNT_ID = 'your-aws-account-id'  // Replace with your AWS account ID
    //     EC2_HOST = 'your-ec2-instance-ip'  // Change to your EC2 instance IP
    //     DEPLOY_USER = 'ec2-user'  // Change if using a different user
    // }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        // stage('Verifying Tools') {
        //     steps {
        //         sh 'node -v'
        //         sh 'npm -v'
        //         sh 'php -v'
        //         sh 'composer --version'
        //         sh 'docker --version'
        //     }
        // }

        // stage('Debugging: Directory Structure') {
        //     steps {
        //         sh 'ls -la'
        //         sh 'ls -la back-end'
        //         sh 'ls -la front-end'
        //     }
        // }

        stage('Linting') {
            parallel {
                stage('Frontend Linting') {
                    steps {
                        dir('front-end') {
                            sh '''
                            npm install
                            npm run lint
                            '''
                        }
                    }
                }
            }
        }

        stage('PHP Testing') {
            steps {
                dir('back-end') {
                    sh 'php artisan test'
                }
            }
        }

        // stage('Build and Push Docker Images') {
        //     steps {
        //         script {
        //             sh '''
        //             aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    
        //             cd back-end
        //             docker build -t $ECR_REPO_BACKEND .
        //             docker tag $ECR_REPO_BACKEND:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_BACKEND:latest
        //             docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_BACKEND:latest
                    
        //             cd ../front-end
        //             docker build -t $ECR_REPO_FRONTEND .
        //             docker tag $ECR_REPO_FRONTEND:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_FRONTEND:latest
        //             docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_FRONTEND:latest
        //             '''
        //         }
        //     }
        // }

        // stage('Deploy to EC2') {
        //     steps {
        //         script {
        //             sh '''
        //             ssh -o StrictHostKeyChecking=no $DEPLOY_USER@$EC2_HOST << 'EOF'
        //             docker pull $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_BACKEND:latest
        //             docker pull $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_FRONTEND:latest
        //             docker-compose down
        //             docker-compose up -d
        //             EOF
        //             '''
        //         }
        //     }
        // }
    }

    post {
        always {
            echo 'Pipeline completed. Checking final status...'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed! Check the logs for errors.'
        }
    }
}
