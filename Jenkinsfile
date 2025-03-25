pipeline {
    agent any

    environment {
        // LARAVEL_DIR = './back-end'  
        // NEXTJS_DIR = './front-end'
        // Add any other environment variables needed
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

        // stage('Verify Directories') {
        //     steps {
        //         script {
        //             if (!fileExists(env.LARAVEL_DIR)) {
        //                 error("Directory ${env.LARAVEL_DIR} does not exist.")
        //             }
        //             if (!fileExists(env.NEXTJS_DIR)) {
        //                 error("Directory ${env.NEXTJS_DIR} does not exist.")
        //             }
        //         }
        //     }
        // }

        // stage('Prepare Laravel') {
        //     steps {
        //         dir(./back-end) {
        //             script {
        //                 // Create required directories with proper permissions
        //                 sh '''
        //                 mkdir -p bootstrap/cache storage/framework/{sessions,views,cache}
        //                 chmod -R 775 bootstrap/cache storage
        //                 chown -R jenkins:jenkins bootstrap/cache storage
        //                 '''
                        
        //                 // Copy .env file if not exists
        //                 sh '''
        //                 if [ ! -f .env ]; then
        //                     cp .env.example .env
        //                     chmod 666 .env
        //                 fi
        //                 '''
        //             }
        //         }
        //     }
        // }

        stage('Lint and Format Check') {
            parallel {
                stage('PHP Lint') {
                    steps {
                        dir(back-end) {
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
                        dir(front-end) {
                            sh '''
                            npm install
                            npm run lint
                            '''
                        }
                    }
                }
            }
        }

        // stage('Testing') {
        //     parallel {
        //         stage('PHP Tests') {
        //             steps {
        //                 dir(env.LARAVEL_DIR) {
        //                     sh 'php artisan test'
        //                 }
        //             }
        //         }

        //         // Uncomment when you have front-end tests
        //         // stage('Next.js Tests') {
        //         //     steps {
        //         //         dir(env.NEXTJS_DIR) {
        //         //             sh 'npm run test'
        //         //         }
        //         //     }
        //         // }
        //     }
        // }
    }

    post {
        always {
            // Clean up or archive artifacts if needed
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