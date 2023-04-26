pipeline {
  agent any

  environment {
    APP_SERVER_HOST = "3.89.253.242"
    APP_SERVER_USER = "root"
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'docker build -t clumsy-bird:${BUILD_NUMBER} .'
      }
    }

    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds',
                                          passwordVariable: 'DOCKER_HUB_PASSWORD',
                                          usernameVariable: 'DOCKER_HUB_USERNAME')]) {
          sh "echo ${DOCKER_HUB_PASSWORD} | docker login --username ${DOCKER_HUB_USERNAME} --password-stdin"
          sh "docker tag clumsy-bird:${BUILD_NUMBER} ${DOCKER_HUB_USERNAME}/clumsy-bird:${BUILD_NUMBER}"
          sh "docker push ${DOCKER_HUB_USERNAME}/clumsy-bird:${BUILD_NUMBER}"
        }
      }
    }

    stage('Deploy') {
      steps {
        sshagent(['app-server-creds']) {
          sh "ssh -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER_HOST} 'docker pull ${DOCKER_HUB_USERNAME}/clumsy-bird:${BUILD_NUMBER}'"
          sh "ssh -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER_HOST} 'docker run -d --name clumsy-bird -p 8001:8000 ${DOCKER_HUB_USERNAME}/clumsy-bird:${BUILD_NUMBER}'"
        }
      }
    }
  }
}
