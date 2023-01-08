pipeline
    agent {
        label 'default'
    }
    tools {
        terraform 'terraform-11'
    }
    
    stages{
        stage('Git Checkout'){
            steps{
                git 'https://github.com/mbr3d4/lab_terraform_proxmmox.git'
            }
        }
        stage('Terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('Terraform Apply'){
            steps{
                sh 'terraform apply --auto-approve'
                }
            }
        }
    }
}{