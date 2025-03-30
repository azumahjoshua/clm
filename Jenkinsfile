pipeline {
    agent any

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

        stage('Build Docker images'){
            parallel{
                stage('Build Frontend Images'){
                    steps{
                    dir('front-end') {
                            sh 'docker build -t clm_frontend:latest .'
                        
                        }
                    }
                }
                stage('Build Backend Image'){
                    dir('back-end'){
                        sh 'docker build -t clm_backend:latest .'
                    }
                }
            }
        }
       
    }

    post {
        // always {
        //     junit 'back-end/tests/**/*.xml'
        //     archiveArtifacts artifacts: 'back-end/storage/logs/*.log', allowEmptyArchive: true
        //     echo 'Pipeline completed. Checking final status...'
        // }
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