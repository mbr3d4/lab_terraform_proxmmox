pipeline {
    agent any
    
    stages {
        stage('Terraform init') {
            steps {
                script{
                sh 'cd tf/vm && terraform init'
                }
            }
        }
              stage('Terraform apply') {
            steps {
                script{
                sh 'cd tf/vm && terraform apply --auto-approve'
                }
            }
        }
    }
}