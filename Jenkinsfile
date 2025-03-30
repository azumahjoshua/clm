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
        stage('Preparing Build Stage'){
            steps{
                echo 'Running...'
            }
        }
        stage('Build Docker Images') {
            parallel {
                stage('Build Frontend Image') {
                    steps {
                        dir('front-end') {
                            sh 'docker build -t clm_frontend:latest .'
                        }
                    }
                }
                stage('Build Backend Image') {
                    steps {
                        dir('back-end') {
                            sh 'docker build -t clm_backend:latest .'
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
            echo 'Pipeline failed! Check logs for errors.'
        }
    }
}
