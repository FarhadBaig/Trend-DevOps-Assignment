
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        IMAGE_NAME = 'farhadbaig/trend-app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Project') {
            steps {
                bat 'git --version'
                bat 'dir'
                bat 'if not exist Dockerfile exit /b 1'
                bat 'if not exist dist\\index.html exit /b 1'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME%:%BUILD_NUMBER% -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    bat '''
                        @echo off
                        echo %DOCKERHUB_TOKEN% | docker login -u %DOCKERHUB_USER% --password-stdin
                        if errorlevel 1 exit /b 1
                        docker push %IMAGE_NAME%:%BUILD_NUMBER%
                        if errorlevel 1 exit /b 1
                        docker push %IMAGE_NAME%:latest
                        if errorlevel 1 exit /b 1
                        docker logout
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Trend CI/CD pipeline finished.'
        }
    }
}
