pipeline {
  agent any
   environment {
        AWS_ACCOUNT_ID     = credentials('jenkins-aws-account-id')
    }
  stages {
    stage('build docker image and tag') {
      steps {
        sh 'sudo docker build -t ssoweb .'
      }
    }
    stage('start env') {
      when {
                changeRequest()
            }
      steps {
        sh '''export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
        docker-compose up -d'''
      }
    }
    stage('run unit test') {
      when {
                changeRequest()
            }
      steps {
        sh './unit_test.sh'
      }
    }
    stage('destroy env') {
      when {
                changeRequest()
            }
      steps {
        sh '''export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
        docker-compose down -v'''
      }
    }
    stage('ecr push') {
      when {
                branch 'master'
            }
      steps {
        sh '''eval sudo $(aws ecr get-login --no-include-email --region us-west-2)
latest_tag=$(aws ecr describe-images --repository-name ssoweb --region us-west-2  --output text --query \'sort_by(imageDetails,& imagePushedAt)[*].imageTags[*]\' | tr \'\\t\' \'\\n\'  | tail -1)
VERSION_TAG="${latest_tag%.*}.$((${latest_tag##*.}+1))"
sudo docker tag ssoweb $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/ssoweb:${VERSION_TAG}
sudo docker push $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/ssoweb:${VERSION_TAG}'''
      }
    }
    stage('deploy to stg') {
      when {
                branch 'master'
            }
      steps {
        sh '''
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
eval sudo $(aws ecr get-login --no-include-email --region us-west-2)
latest_tag=$(aws ecr describe-images --repository-name ssoweb --region us-west-2  --output text --query \'sort_by(imageDetails,& imagePushedAt)[*].imageTags[*]\' | tr \'\\t\' \'\\n\'  | tail -1)
sleep 60
fluxctl release --k8s-fwd-ns=flux --workload=dev:helmrelease/rubycas-dev --namespace=dev --update-image=$AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/ssoweb:${latest_tag}
'''
      }
    }
    stage('stg test execution ') {
      when {
                branch 'master'
            }
      steps {
        sh './int_test.sh'
      }
    }
    stage('deploy to prod') {
      when {
                branch 'master'
            }
      steps {
        sh 'echo "this will deploy to next env"'
      }
    }
  }
  triggers {
    pollSCM('* * * * *')
  }
}
