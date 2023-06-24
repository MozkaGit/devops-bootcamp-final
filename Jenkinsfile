pipeline {
    agent none
    stages {
        // stage('Build image') {
        //     agent any
        //     steps {
        //         script {
        //             sh 'docker build -t icwebapp .'
        //         }
        //     }
        // }
        stage('Push IC Webapp and Pgadmin in deployment') {
            agent {
                docker { image 'coxauto/aws-ebcli' }
            }
            environment {
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            }
            steps {
                script {
                sh '''
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws configure set region us-east-1
                    eb init --region us-east-1 --platform Docker ic-webapp_$BUILD_NUMBER
                    eb create ic-env-$BUILD_NUMBER
                    eb status
                '''
                }
            }
        }
        stage('Push Odoo in deployment') {
            agent {
                docker { image 'coxauto/aws-ebcli' }
            }
            environment {
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            }
            steps {
                script {
                sh '''
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws configure set region us-east-1
                    eb init --region us-east-1 --platform Docker odoo_$BUILD_NUMBER
                    eb create odoo-env-$BUILD_NUMBER
                    eb status
                '''
                }
            }
        }
    }
}