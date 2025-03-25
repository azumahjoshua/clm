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

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Prepare Laravel Environment') {
            steps {
                dir(env.LARAVEL_DIR) {
                    // Create required directories with proper permissions
                    sh '''
                    mkdir -p bootstrap/cache storage/framework/{sessions,views,cache}
                    chmod -R 775 bootstrap/cache storage
                    '''
                    
                    // Copy .env file if not exists
                    sh '''
                    if [ ! -f .env ]; then
                        cp .env.example .env
                        chmod 666 .env
                    fi
                    '''
                }
            }
        }

        stage('Lint and Format Check') {
            parallel {
                stage('PHP Lint') {
                    steps {
                        dir(env.LARAVEL_DIR) {
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
                        dir(env.NEXTJS_DIR) {
                            sh '''
                            npm install
                            npm run lint
                            '''
                        }
                    }
                }
            }
        }

        stage('Testing') {
            parallel {
                stage('PHP Tests') {
                    steps {
                        dir(env.LARAVEL_DIR) {
                            sh 'php artisan test'
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