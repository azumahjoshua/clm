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

        stage('Verify Environment') {
            steps {
                script {
                    if (!fileExists(env.LARAVEL_DIR)) {
                        error("Laravel directory not found at ${env.LARAVEL_DIR}")
                    }
                    if (!fileExists("${env.LARAVEL_DIR}/.env")) {
                        error(".env file not found in Laravel directory")
                    }
                }
            }
        }

//         stage('Prepare Laravel') {
//     steps {
//         dir(env.LARAVEL_DIR) {
//             sh '''
//             mkdir -p bootstrap/cache storage/framework/{sessions,views,cache}
//             chmod -R 775 bootstrap/cache storage
//             '''
            
//             script {
//                 if (!fileExists('.env')) {
//                     if (fileExists('.env')) {
//                         sh 'cp .env .env'
//                         sh 'chmod 644 .env'
//                     } else {
//                         error("No .env file found and no .env to create from")
//                     }
//                 } else {
//                     sh 'chmod 644 .env'
//                 }
//             }
//         }
//     }
// }

        // stage('Install Dependencies') {
        //     steps {
        //         dir(env.LARAVEL_DIR) {
        //             sh '''
        //             composer require "spatie/laravel-data:^4.14" --no-interaction
        //             composer install --no-interaction --prefer-dist --optimize-autoloader
        //             php artisan vendor:publish --tag=laravel-assets --ansi --force || true
        //             php artisan key:generate
        //             php artisan config:clear
        //             php artisan package:discover --ansi
        //             '''
        //         }
        //     }
        // }

        stage('Lint and Test') {
            parallel {
                stage('PHP Tests') {
                    steps {
                        dir(env.LARAVEL_DIR) {
                            sh 'php artisan test'
                        }
                    }
                }
                stage('Frontend Lint') {
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