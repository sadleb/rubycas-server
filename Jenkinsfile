pipeline {
  agent any
  stages {
    stage('build docker image and tag') {
      steps {
        sh 'sudo docker build -t ssoweb .'
      }
    }
    stage('git tag') {
      steps {
        sh 'ls'
      }
    }
    stage('ecr push') {
      steps {
        sh '''eval sudo $(aws ecr get-login --no-include-email --region us-west-2)
latest_tag=$(aws ecr describe-images --repository-name ssoweb --region us-west-2  --output text --query \'sort_by(imageDetails,& imagePushedAt)[*].imageTags[*]\' | tr \'\\t\' \'\\n\'  | tail -1)
VERSION_TAG="${latest_tag%.*}.$((${latest_tag##*.}+1))"
sudo docker tag ssoweb 958491237157.dkr.ecr.us-west-2.amazonaws.com/ssoweb:${VERSION_TAG}
sudo docker push 958491237157.dkr.ecr.us-west-2.amazonaws.com/ssoweb:${VERSION_TAG}'''
      }
    }
    stage('deploy to int') {
      steps {
        sh '''eval sudo $(aws ecr get-login --no-include-email --region us-west-2)
latest_tag=$(aws ecr describe-images --repository-name ssoweb --region us-west-2  --output text --query \'sort_by(imageDetails,& imagePushedAt)[*].imageTags[*]\' | tr \'\\t\' \'\\n\'  | tail -1)
kubectl --record deployment.apps/ssoweb set image deployment.v1.apps/ssoweb ssoweb=958491237157.dkr.ecr.us-west-2.amazonaws.com/ssoweb:${latest_tag}'''
      }
    }
  }
  triggers {
    pollSCM('* * * * *')
  }
}