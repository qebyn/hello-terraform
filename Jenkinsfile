pipeline {
  agent any
  environment {
    TF_VAR_instance_name = 'instance_name'
    TF_VAR_app_name = 'app_name'
  }
  stages {
    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }
    stage('Terraform Apply') {
      steps {
        script {
          withAWS(credentials:'my-aws-credentials') {
            def region = 'eu-west-1'
            def tfVars = "-var 'region=${region}'"
            sh "terraform apply ${tfVars} -auto-approve"
          }
        }
      }
    }
    stage('Deployment') {
      steps {
        script {
          withAWS(credentials: 'my-aws-credentials', region: 'eu-west-1') {
            sh 'cd ansible'
            sh 'ansible-playbook -i aws_ec2.yml ec2-dockerconfig.yml'
          }
        }
      }
    }
  }
}

