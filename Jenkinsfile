pipeline {
    agent any
    
    stages {
        stage('Terraform init') {
            steps {
                script{
                sh '/tf/vm terraform init'
                }
            }
        }
              stage('Terraform apply') {
            steps {
                script{
                sh '/tf/vm terraform apply --auto-approve'
                }
            }
        }
    }
}