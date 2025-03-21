pipeline {
    agent any

    environment {
        // Define environment variables here
        LARAVEL_DIR = 'back-end'  // Update with your Laravel app path
        NEXTJS_DIR = 'front-end'  // Update with your Next.js app path
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

        // Debugging: Print directory structure
        stage('Debugging: Directory Structure') {
            steps {
                sh 'ls -la'
                sh 'ls -la back-end || true'
                sh 'ls -la front-end || true'
            }
        }

        // Verify directories exist
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

        // Lint and format checks
        // stage('Lint and Format Check') {
        //     parallel {
        //         // Laravel PHP Lint
        //         stage('PHP Lint') {
        //             steps {
        //                 dir(env.LARAVEL_DIR) {
        //                     script {
        //                         if (fileExists('composer.json')) {
        //                             sh 'composer install --no-interaction --prefer-dist --optimize-autoloader'
        //                             sh 'vendor/bin/phpcs --standard=PSR12 app/'
        //                         } else {
        //                             error("composer.json not found in ${env.LARAVEL_DIR}")
        //                         }
        //                     }
        //                 }
        //             }
        //         }

        //         // Next.js JavaScript/TypeScript Lint
        //         stage('JavaScript/TypeScript Lint') {
        //             steps {
        //                 dir(env.NEXTJS_DIR) {
        //                     script {
        //                         if (fileExists('package.json')) {
        //                             sh 'npm install'
        //                             sh 'npm run lint'
        //                         } else {
        //                             error("package.json not found in ${env.NEXTJS_DIR}")
        //                         }
        //                     }
        //                 }
        //             }
        //         }
        //     }
        // }

        // Run tests
        // stage('Testing') {
        //     parallel {
        //         // Laravel PHP Tests
        //         stage('PHP Tests') {
        //             steps {
        //                 dir(env.LARAVEL_DIR) {
        //                     script {
        //                         if (fileExists('composer.json')) {
        //                             sh 'php artisan test'
        //                         } else {
        //                             error("composer.json not found in ${env.LARAVEL_DIR}")
        //                         }
        //                     }
        //                 }
        //             }
        //         }

        //         // Next.js Tests
        //         stage('Next.js Tests') {
        //             steps {
        //                 dir(env.NEXTJS_DIR) {
        //                     script {
        //                         if (fileExists('package.json')) {
        //                             sh 'npm run test'
        //                         } else {
        //                             error("package.json not found in ${env.NEXTJS_DIR}")
        //                         }
        //                     }
        //                 }
        //             }
        //         }
        //     }
        // }
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