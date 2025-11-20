pipeline {
    agent any

    environment {
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
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
                        sh """
                        echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin
                        """
                    }
                }
            }
        }

        // Skip Docker Push stage
        // You can remove this stage entirely if you don't need to push to DockerHub
        // stage("Push to DockerHub") {
        //     steps {
        //         sh """
        //         docker tag ${IMAGE_NAME}:${IMAGE_TAG} \$DOCKERHUB_CREDENTIALS_USR/${IMAGE_NAME}:${IMAGE_TAG}
        //         docker push \$DOCKERHUB_CREDENTIALS_USR/${IMAGE_NAME}:${IMAGE_TAG}
        //         """
        //     }
        // }

        stage("Deploy") {
            steps {
                script {
                    // You can deploy the container directly on the local system (Jenkins server)
                    sh """
                    docker stop notes-app || true
                    docker rm notes-app || true
                    docker run -d -p 8000:8000 --name notes-app ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
}
