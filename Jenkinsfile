pipeline {
    agent any

    stages {
        stage("Infrastructure"){
            steps {
                withAWS(credentials: 'aws_access_key', region: 'eu-west-1') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage("Deployment"){
            steps {
                dir('ansible') {
                    sshagent(['ssh-amazon-qebyn']){
                        withAWS(credentials: 'aws_access_key', region: 'eu-west-1')  {
                            sh 'ansible-playbook -i aws_ec2.yml ec2-dockerconfig.yml'
                        }
                    }
                }
            }
        }
    }
}
