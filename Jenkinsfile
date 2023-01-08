pipeline{
    agent any
    tools{
        terraform 'terraform-11'
    }
    stages{
        stage('terraform init'){
            steps{
                sh label: '', script:'terraform init'
            }
        }
        stage('terraform apply'){
            steps{
                sh label: '', script:'terraform apply --auto-aprove'
            }
        }
    }
}