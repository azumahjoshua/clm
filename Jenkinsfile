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

        // Lint and format checks
        stage('Lint and Format Check') {
            parallel {
                // Laravel PHP Lint
                stage('PHP Lint') {
                    steps {dir('back-end') {
                        sh '''
                        composer install --no-interaction --prefer-dist --optimize-autoloader
                        php artisan package:discover --ansi
                        '''
                        }
                    }
                }

                // Next.js JavaScript/TypeScript Lint
                stage('JavaScript/TypeScript Lint') {
                    steps {
                        dir(env.NEXTJS_DIR) {
                            script {
                                if (fileExists('package.json')) {
                                    sh 'npm install'
                                    sh 'npm run lint'
                                } else {
                                    error("package.json not found in ${env.NEXTJS_DIR}")
                                }
                            }
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
                            script {
                                if (fileExists('composer.json')) {
                                    sh 'php artisan test'
                                } else {
                                    error("composer.json not found in ${env.LARAVEL_DIR}")
                                }
                            }
                        }
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
