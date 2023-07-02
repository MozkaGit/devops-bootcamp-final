pipeline {
    environment {
        IMAGE_NAME = "ic-webapp"
        STAGING = "ic-webapp-staging"
        PRODUCTION = "ic-webapp-prod"
    }
    agent none
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh 'docker build -f app/Dockerfile -t $IMAGE_NAME:$BUILD_NUMBER .'
                }
            }
        }
        stage('Run container based on build image') {
            agent any
            steps {
                script {
                    sh '''
                        docker run --name $IMAGE_NAME -d -p 80:8080 $IMAGE_NAME:$BUILD_NUMBER
                        sleep 5
                    '''
                }
            }
        }
        stage('Test container') {
            agent any
            steps {
                script {
                    sh '''
                        curl http://172.17.0.1 | grep 'IC GROUP'
                        if [ $? -eq 0 ]; then echo "Acceptance test succeed"; fi
                    '''
                }
            }
        }
        stage('Delete container') {
            agent any
            steps {
                script {
                    sh 'docker rm -f $IMAGE_NAME'
                }
            }
        }
        stage('Push image to Docker Hub') {
            agent any
            environment {
                DOCKER_CREDENTIALS = credentials('docker-credentials')
            }
            steps {
                script {
                sh '''
                    echo $DOCKER_CREDENTIALS_PSW | docker login -u $DOCKER_CREDENTIALS_USR --password-stdin
                    docker tag $IMAGE_NAME:$BUILD_NUMBER mozkadocker/$IMAGE_NAME:$BUILD_NUMBER
                    docker push mozkadocker/$IMAGE_NAME:$BUILD_NUMBER
                '''
                }
            }
        }
    }
    post {
        success {
            slackSend (color: "#028000", message: "Pipeline succeed")
        }
        failure {
            slackSend (color: "#c70039", message: "Pipeline failed")
        }
    }
}
