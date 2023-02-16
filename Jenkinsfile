pipeline {
    agent any

    stages {
 
        stage('BuildDocker') {
        

            steps {
                dir("docker") {
                    sh 'docker-compose build'
                    sh 'git tag 1.0.${BUILD_NUMBER}'
                    sshagent(['github_access_ssh']) {
                        sh 'git push --tags'
                    }
           
                    sh "docker tag ghcr.io/qebyn/hello-terraform/nginx2048:latest ghcr.io/qebyn/hello-terraform/nginx2048:1.0.${BUILD_NUMBER}"
                }
            }
        }
        stage('Dockerlogin'){
           steps {
                withCredentials([string(credentialsId: 'github-tokenqebyn', variable: 'PAT')]) {
                    dir("docker") {
                        sh 'echo $PAT | docker login ghcr.io -u qebyn --password-stdin && docker-compose push && docker push ghcr.io/qebyn/hello-terraform/nginx2048:1.0.${BUILD_NUMBER}'

                    }
                }
            }
        }


        stage('Buildingterraform') {
            steps {
                withAWS(credentials:'aws_access_key') {
                   sshagent(['ssh-amazon']) {
                dir("terraform") {  
			        sh 'terraform init'
                    sh 'terraform apply -auto-approve'

                    }
                }
            }
        }

    }
}
}


