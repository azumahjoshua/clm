pipeline {
    agent any
    stages {
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

        stage('Debugging: Directory Structure'){
            steps{
                sh 'ls -la'
                sh 'ls -la back-end'
                sh 'ls -la front-end'
            }
        }
        stage('Backend Linting') {
            parallel {
                stage('PHP Lint') {
                    steps {
                        dir('back-end') {
                            sh '''
                            sudo mkdir -p bootstrap/cache
                            sudo chmod -R 775 bootstrap/cache
                            sudo chown -R jenkins:jenkins bootstrap/cache
                            '''
                            sh '''
                            composer install --no-interaction --prefer-dist --optimize-autoloader
                            php artisan key:generate
                            php artisan package:discover --ansi
                            '''
                        }
                    }
                }

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
