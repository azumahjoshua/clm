pipeline {
    agent any

    environment {
        DB_CONNECTION = 'pgsql'
        DB_HOST = 'dpg-cv1doh56l47c73fd037g-a.oregon-postgres.render.com'
        DB_PORT = '5432'
        DB_DATABASE = 'laravel_db_mx96'
        DB_USERNAME = 'laravel_db'
        // DB_PASSWORD = credentials('DB_PASSWORD')
        DB_PASSWORD = 'NdYV7AwLbXC1GQlpIfpggrtLOSREA53J'
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

        stage('Install Dependencies') {
            parallel {
                stage('Frontend') {
                    steps {
                        dir('front-end') {
                            sh 'npm install'
                        }
                    }
                }
                stage('Backend') {
                    steps {
                        dir('back-end') {
                            sh'''
                            sudo mkdir -p bootstrap/cache
                            sudo chmod -R 775 bootstrap/cache
                            sudo chown -R jenkins:jenkins bootstrap/cache
                            '''
                            sh 'composer install --no-interaction --prefer-dist --optimize-autoloader'

                            sh '''
                            composer remove spatie/data-transfer-object
                            composer require spatie/laravel-data
                            '''
                        }
                    }
                }
            }
        }

        // stage('Linting') {
        //     parallel {
        //         stage('Frontend Linting') {
        //             steps {
        //                 dir('front-end') {
        //                     sh 'npm run lint'
        //                 }
        //             }
        //         }
        //         stage('Backend Linting') {
        //             steps {
        //                 dir('back-end') {
        //                     sh 'php ./vendor/bin/phpstan analyse'
        //                     sh 'php ./vendor/bin/pint --test'
        //                 }
        //             }
        //         }
        //     }
        // }

        // stage('Setup Environment') {
        //     steps {
        //         dir('back-end') {
        //             sh '''
        //             cat > .env.testing <<EOL
        //             DB_CONNECTION=$DB_CONNECTION
        //             DB_HOST=$DB_HOST
        //             DB_PORT=$DB_PORT
        //             DB_DATABASE=$DB_DATABASE
        //             DB_USERNAME=$DB_USERNAME
        //             DB_PASSWORD=$DB_PASSWORD
        //             EOL
        //             '''
        //             sh 'php artisan config:clear'
        //             sh 'php artisan cache:clear'
        //         }
        //     }
        // }

        // stage('Run Migrations') {
        //     steps {
        //         dir('back-end') {
        //             retry(3) {
        //                 timeout(time: 5, unit: 'MINUTES') {
        //                     sh 'php artisan migrate:fresh --env=testing --force --seed'
        //                 }
        //             }
        //         }
        //     }
        // }

        // stage('Testing') {
        //     parallel {
        //         stage('PHP Unit Tests') {
        //             steps {
        //                 dir('back-end') {
        //                     sh 'php artisan test'
        //                 }
        //             }
        //         }
        //         stage('Frontend Tests') {
        //             steps {
        //                 sh '''
        //                 echo "Frontend Testing!!!
        //                 '''
        //                 // dir('front-end') {
        //                 //     sh 'npm test'
        //                 // }
        //             }
        //         }
        //     }
        // }

        // stage('Cleanup') {
        //     steps {
        //         dir('back-end') {
        //             sh 'php artisan migrate:reset --env=testing'
        //         }
        //     }
        // }
    }

    post {
        always {
            junit 'back-end/tests/**/*.xml'
            archiveArtifacts artifacts: 'back-end/storage/logs/*.log', allowEmptyArchive: true
            echo 'Pipeline completed. Checking final status...'
        }
        success {
            echo 'Pipeline succeeded!'
            // mail to: 'team@example.com', subject: 'Pipeline Success', body: 'Build succeeded'
        }
        failure {
            echo 'Pipeline failed! Check the logs for errors.'
            // mail to: 'team@example.com', subject: 'Pipeline Failed', body: 'Build failed'
        }
    }
}