pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('github-creds')
        IMAGE_NAME = "notes-app"
        IMAGE_TAG = "latest"
    }

    stages {

        stage("Verify Code") {
            steps {
                sh "ls -la"
            }
        }

        stage("Build Docker Image") {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage("Docker Login") {
            steps {
                sh """
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                """
            }
        }

        stage("Push to DockerHub") {
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} $DOCKERHUB_CREDENTIALS_USR/${IMAGE_NAME}:${IMAGE_TAG}
                docker push $DOCKERHUB_CREDENTIALS_USR/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage("Deploy") {
            steps {
                sh """
                docker stop notes-app || true
                docker rm notes-app || true
                docker run -d -p 8000:8000 --name notes-app $DOCKERHUB_CREDENTIALS_USR/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }
}
