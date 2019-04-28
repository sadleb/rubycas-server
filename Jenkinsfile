pipeline {
  agent any
  stages {
    stage('build docker image') {
      steps {
        sh 'sudo docker build -t ssoweb .'
      }
    }
    stage('git tag') {
      steps {
        sh '''VERSION=1.0.0

# Tag Github repo with version prefix 
prefix=1.0
latest_tag=$(git ls-remote --tags origin | cut -f 3 -d \'/\' | grep "^${prefix}" | sort -t. -k 3,3nr | head -1)
if [ -z ${latest_tag} ]; then
  VERSION_TAG="${VERSION}"
else
  VERSION_TAG="${latest_tag%.*}.$((${latest_tag##*.}+1))"
fi
git tag ${VERSION_TAG}
git push --tags'''
      }
    }
    stage('ecr push') {
      steps {
        sh '''eval sudo $(aws ecr get-login --no-include-email --region us-west-2)
latest_tag=$(git ls-remote --tags origin | cut -f 3 -d \'/\' | grep "^${prefix}" | sort -t. -k 3,3nr | head -1)
sudo docker tag ssoweb 958491237157.dkr.ecr.us-west-2.amazonaws.com/ssoweb:latest_tag
sudo docker push 958491237157.dkr.ecr.us-west-2.amazonaws.com/ssoweb:latest_tag'''
      }
    }
  }
  triggers {
    pollSCM('* * * * *')
  }
}