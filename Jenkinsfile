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
                    withCredentials([usernamePassword(
                        credentialsId: 'github-creds', 
                        usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', 
                        passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
                        sh """
                        echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin
                        """
                    }
                }
            }
        }

        stage("Deploy") {
            steps {
                script {
                    // Stop & remove old container if exists
                    sh """
                    docker stop notes-app || true
                    docker rm notes-app || true
                    """

                    // Run container with Django settings
                    sh """
                    docker run -d -p 8000:8000 --name notes-app \\
                        -e DJANGO_SETTINGS_MODULE=notesapp.settings.dev \\
                        ${IMAGE_NAME}:${IMAGE_TAG} \\
                        bash -c "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Notes App deployed on port 8000"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}
