pipeline {
    agent any

    environment {
        LARAVEL_DIR = './back-end'  
        NEXTJS_DIR = './front-end'  
    }

    stages {
        stage('Cleaning Workspace') {
            steps {
                cleanWs()
            }
        }

        // Clone the repository
        stage('Checkout Code') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Verifying Tools') {
            steps {
                script {
                    sh 'node -v'
                    sh 'npm -v'
                    sh 'php -v'
                    sh 'composer --version'
                    sh 'docker --version'
                }
            }
        }

        stage('Debugging: Directory Structure') {
            steps {
                sh 'ls -la'
                sh 'ls -la back-end || true'
                sh 'ls -la front-end || true'
            }
        }

        stage('Verify Directories') {
            steps {
                script {
                    if (!fileExists(env.LARAVEL_DIR)) {
                        error("Directory ${env.LARAVEL_DIR} does not exist.")
                    }
                    if (!fileExists(env.NEXTJS_DIR)) {
                        error("Directory ${env.NEXTJS_DIR} does not exist.")
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed! Check the logs for errors.'
        }
    }
}
