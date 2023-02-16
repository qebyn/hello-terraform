pipeline {
    agent any

    stages {

        stage('Build Docker Image') {
            steps {
                dir("docker") {
                    sh 'docker-compose build'
                    sh 'git tag 1.0.${BUILD_NUMBER}'
                    sshagent(['github_access_ssh']) {
                        sh 'git push --tags'
                    }
                }
            }
        }

        stage('Tag and Push Docker Image') {
            steps {
                dir("docker") {
                    sh "docker tag ghcr.io/qebyn/hello-terraform/nginx2048:latest ghcr.io/qebyn/hello-terraform/nginx2048:1.0.${BUILD_NUMBER}"
                }
                withCredentials([string(credentialsId: 'github-tokenqebyn', variable: 'PAT')]) {
                    dir("docker") {
                        sh 'echo $PAT | docker login ghcr.io -u qebyn --password-stdin'
                        sh 'docker-compose push'
                        sh "docker push ghcr.io/qebyn/hello-terraform/nginx2048:1.0.${BUILD_NUMBER}"
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                withAWS(credentials:'aws_access_key') {
                    sshagent(['ssh-amazon']) {
                        dir("terraform") {
                            sh 'terraform init'
                            sh 'terraform validate'
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }
    }
}
