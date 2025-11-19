pipeline {
    agent { label 'dev-server' }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerHubCreds')
        IMAGE_NAME = "notes-app"
        IMAGE_TAG = "latest"
    }

    stages {
        stage("Clone Code") {
            steps {
                sh "git clone https://github.com/zahid-IT/django-notes-app.git"
            }
        }

        stage("Build Docker Image") {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ./django-notes-app
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
