pipeline {
    agent any
    environment {
        ANSIBLE_PRIVATE_KEY=credentials('id_rsa.pub')
    }
    
    stages {
       stage('Terraform init'){
            steps{
                dir("tf") {
                    sh 'terraform init'
               }
            }
        }
       stage('Terraform apply'){
            steps{
                dir("tf") {
                    sh 'terraform apply --auto-approve'
               }
            }
        }
       stage('Ansible Docker'){
            steps{
                dir("ansible") {
                    sh 'ansible-playbook -i hosts --private-key=$ANSIBLE_PRIVATE_KEY playbook.yml'
               }
            }
        }
    }
}