pipeline {
    agent any
    
    stages {
        stage('Terraform init') {
            steps {
                script{
                    dir('tf')
                        sh 'terraform init'
                }
            }
        }
        stage('Terraform apply') {
            steps {
                script{
                    dir('tf')
                        sh 'terraform apply --auto-approve'
                }
            }
        }
    }
}