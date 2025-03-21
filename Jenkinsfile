pipeline {
    agent any

    environment {
        // AWS ECR Configuration
        AWS_ACCOUNT_ID = "123456789012"
        AWS_REGION = "us-east-1" 
        BACKEND_REPOSITORY = "clm_backend"
        FRONTEND_REPOSITORY = "clm_frontend"
        AWS_CREDENTIALS = credentials('aws-credentials') 
        BACKEND_APP_NAME = "clm_backend" 
        FRONTEND_APP_NAME = "clm_frontend" 

        // Application Directories
        LARAVEL_DIR = "back-end" 
        NEXTJS_DIR = "front-end"   
    }

    stages {
        // Clean up workspace before starting
        stage('Cleaning Workspace') {
            steps {
                cleanWs()
            }
        }

        // Verify installed tools
        stage('Verifying Tools') {
            steps {
                script {
                    // Check Node.js and npm (for Next.js)
                    try {
                        sh 'node -v'
                        sh 'npm -v'
                    } catch (Exception e) {
                        error("Node.js or npm is not installed. Error: ${e}")
                    }

                    // Check PHP and Composer (for Laravel)
                    try {
                        sh 'php -v'
                        sh 'composer --version'
                    } catch (Exception e) {
                        error("PHP or Composer is not installed. Error: ${e}")
                    }

                    // Check Docker
                    try {
                        sh 'docker --version'
                    } catch (Exception e) {
                        error("Docker is not installed. Error: ${e}")
                    }
                }
            }
        }

        // Lint and format checks
        stage('Lint and Format Check') {
            parallel {
                // Laravel PHP Lint
                stage('PHP Lint') {
                    steps {
                        dir(env.LARAVEL_DIR) {
                            sh 'composer install --no-interaction --prefer-dist --optimize-autoloader'
                            sh 'vendor/bin/phpcs --standard=PSR12 app/'
                        }
                    }
                }

                // Next.js JavaScript/TypeScript Lint
                stage('JavaScript/TypeScript Lint') {
                    steps {
                        dir(env.NEXTJS_DIR) {
                            sh 'npm install'
                            sh 'npm run lint'
                        }
                    }
                }
            }
        }

        // Run tests
        stage('Testing') {
            parallel {
                // Laravel PHP Tests
                stage('PHP Tests') {
                    steps {
                        dir(env.LARAVEL_DIR) {
                            sh 'php artisan test'
                        }
                    }
                }

                // Next.js Tests
                stage('Next.js Tests') {
                    steps {
                        dir(env.NEXTJS_DIR) {
                            sh 'npm run test'
                        }
                    }
                }
            }
        }

         // Debug Stage
        stage('Debuging') {
            steps {
                script {
                    sh 'pwd'
                    sh 'ls -la'
                }
            }
        }
        // // Build and push Docker images to AWS ECR
        // stage('Build and Push Docker Images') {
        //     steps {
        //         script {
        //             // Authenticate Docker to AWS ECR
        //             sh "aws ecr get-login-password --region ${env.AWS_REGION} | docker login --username AWS --password-stdin ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com"

        //             // Build and push Laravel backend image
        //             dir(env.LARAVEL_DIR) {
        //                 sh "docker build -t ${env.BACKEND_APP_NAME}:latest ."
        //                 sh "docker tag ${env.BACKEND_APP_NAME}:latest ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.ECR_REPOSITORY}:${env.BACKEND_APP_NAME}-latest"
        //                 sh "docker push ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.ECR_REPOSITORY}:${env.BACKEND_APP_NAME}-latest"
        //             }

        //             // Build and push Next.js frontend image
        //             dir(env.NEXTJS_DIR) {
        //                 sh "docker build -t ${env.FRONTEND_APP_NAME}:latest ."
        //                 sh "docker tag ${env.FRONTEND_APP_NAME}:latest ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.ECR_REPOSITORY}:${env.FRONTEND_APP_NAME}-latest"
        //                 sh "docker push ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.ECR_REPOSITORY}:${env.FRONTEND_APP_NAME}-latest"
        //             }
        //         }
        //     }
        // }
    }

    post {
        success {
            echo 'Pipeline succeeded! Images built and pushed to AWS ECR.'
        }
        failure {
            echo 'Pipeline failed! Check the logs for errors.'
        }
    }
}