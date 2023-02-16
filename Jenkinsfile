pipeline {
    agent any

    stages {
        stage('Testing') {
            steps {
                   sh 'docker-compose config'
                withAWS(credentials:'aws_access_key') {
		   sh 'terraform init && terraform validate'
                }
            }
        }
        stage('BuildDocker') {
            steps {
                sh 'docker-compose build'
                sh 'git tag 1.0.${BUILD_NUMBER}'
                sshagent(['github_access_ss']) {
                        sh 'git push --tags'
                }
                sh "docker tag ghcr.io/qebyn/hello-terraform:latest ghcr.io/qebyn/hello-terraform:1.0.${BUILD_NUMBER}"
            }
        }
        stage('Dockerlogin'){
           steps {
             withCredentials([string(credentialsId: 'github-tokenqebyn', variable: 'PAT')]) {
                 sh 'echo $PAT | docker login ghcr.io -u qebyn --password-stdin && docker-compose push && docker push ghcr.io/qebyn/hello-terraform:1.0.${BUILD_NUMBER}'

             }

           }
        }

        stage('Buildingterraform') {
            steps {
                withAWS(credentials:'aws_access_key') {
                   sshagent(['ssh-amazon']) {
			sh 'terraform apply -auto-approve'  
                    }
                }
            }
        }

    }
}
