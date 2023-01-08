pipeline {
    agent any
    
    stages {
        stage('checkuot source'){
            steps {
                git url: 'https://github.com/mbr3d4/lab_terraform_proxmmox.git', branch: 'main'
            }
        }
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