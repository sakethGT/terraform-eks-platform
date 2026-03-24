pipeline {
    agent any

    parameters {
        choice(name: 'STACK', choices: ['dev-npe', 'mgmt-npe', 'mgmt-ri', 'mgmt-euw1-pe'], description: 'Target environment stack')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform action')
    }

    stages {
        stage('Init') {
            steps {
                dir("stacks/${params.STACK}") {
                    sh 'terraform init -backend=true'
                }
            }
        }
        stage('Plan') {
            steps {
                dir("stacks/${params.STACK}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        stage('Apply') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                dir("stacks/${params.STACK}") {
                    sh 'terraform apply tfplan'
                }
            }
        }
    }
}
