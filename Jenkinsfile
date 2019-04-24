pipeline {
  agent any
  stages {
    stage('build docker image') {
      steps {
        sh 'sudo docker build -t ssoweb .'
      }
    }
    stage('ecr push') {
      steps {
        sh '''eval $(shell aws ecr get-login --no-include-email --region us-west-2)
docker tag ssoweb 958491237157.dkr.ecr.us-west-2.amazonaws.com/ssoweb:latest
docker push 958491237157.dkr.ecr.us-west-2.amazonaws.com/ssoweb:latest'''
      }
    }
  }
}