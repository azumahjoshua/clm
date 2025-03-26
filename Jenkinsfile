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
        
        stage('Cleaning Workspace') {
            steps {
                cleanWs()
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
