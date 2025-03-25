pipeline {
    agent any

    // environment {
    //     LARAVEL_DIR = './back-end'  
    //     NEXTJS_DIR = './front-end'
    //     // Add any other environment variables needed
    // }

    stages {
        stage('Cleaning Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Verifying Tools') {
            steps {
                sh 'node -v'
                sh 'npm -v'
                sh 'php -v'
                sh 'composer --version'
                sh 'docker --version'
            }
        }

        stage('Debugging: Directory Structure') {
            steps {
                sh 'ls -la'
                sh 'ls -la back-end || true'
                sh 'ls -la front-end || true'
            }
        }

        stage('Lint and Format Check') {
            parallel {
                stage('PHP Lint') {
                    steps {
                        dir('back-end') {
                            sh '''
                            composer install --no-interaction --prefer-dist --optimize-autoloader
                            php artisan key:generate
                            php artisan package:discover --ansi
                            '''
                        }
                    }
                }

                stage('JavaScript/TypeScript Lint') {
                    steps {
                        dir('front-end') {
                            sh '''
                            npm ci
                            npm run lint
                            '''
                        }
                    }
                }
            }
        }
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
            // You might want to add notification here
        }
    }
}
