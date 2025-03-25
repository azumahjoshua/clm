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
        stage('Prepare Laravel') {
            steps {
                dir(env.LARAVEL_DIR) {
                    script {
                        sh 'mkdir -p bootstrap/cache'
                        sh 'chmod -R 775 bootstrap/cache'
                        sh 'sudo chown -R jenkins:jenkins storage bootstrap/cache'
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
                            script {
                                if (fileExists('composer.json')) {
                                    sh 'composer install --no-interaction --prefer-dist --optimize-autoloader'
                                    sh 'vendor/bin/phpcs --standard=PSR12 app/'
                                } else {
                                    error("composer.json not found in ${env.LARAVEL_DIR}")
                                }
                            }
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

                // // Next.js Tests
                // stage('Next.js Tests') {
                //     steps {
                //         dir(env.NEXTJS_DIR) {
                //             script {
                //                 if (fileExists('package.json')) {
                //                     sh 'npm run test'
                //                 } else {
                //                     error("package.json not found in ${env.NEXTJS_DIR}")
                //                 }
                //             }
                //         }
                //     }
                // }
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
