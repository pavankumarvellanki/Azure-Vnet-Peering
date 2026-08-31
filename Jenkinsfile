pipeline {
  agent {
    docker {
      image 'hashicorp/terraform:1.5.7'
      args  '-u root:root'
    }
  }

  environment {
    TF_IN_AUTOMATION = '1'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Fmt') {
      steps {
        sh 'cd TF-Files && terraform fmt -check -diff'
      }
    }

    stage('Terraform Init') {
      steps {
        withCredentials([
          string(credentialsId: 'azure-client-id', variable: 'ARM_CLIENT_ID'),
          string(credentialsId: 'azure-client-secret', variable: 'ARM_CLIENT_SECRET'),
          string(credentialsId: 'azure-tenant-id', variable: 'ARM_TENANT_ID'),
          string(credentialsId: 'azure-subscription-id', variable: 'ARM_SUBSCRIPTION_ID')
        ]) {
          sh 'cd TF-Files && terraform init -input=false'
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        withCredentials([
          string(credentialsId: 'azure-client-id', variable: 'ARM_CLIENT_ID'),
          string(credentialsId: 'azure-client-secret', variable: 'ARM_CLIENT_SECRET'),
          string(credentialsId: 'azure-tenant-id', variable: 'ARM_TENANT_ID'),
          string(credentialsId: 'azure-subscription-id', variable: 'ARM_SUBSCRIPTION_ID')
        ]) {
          sh 'cd TF-Files && terraform validate'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        withCredentials([
          string(credentialsId: 'azure-client-id', variable: 'ARM_CLIENT_ID'),
          string(credentialsId: 'azure-client-secret', variable: 'ARM_CLIENT_SECRET'),
          string(credentialsId: 'azure-tenant-id', variable: 'ARM_TENANT_ID'),
          string(credentialsId: 'azure-subscription-id', variable: 'ARM_SUBSCRIPTION_ID')
        ]) {
          sh 'cd TF-Files && terraform plan -out=tfplan -input=false'
        }
      }
    }

    stage('Terraform Apply') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([
          string(credentialsId: 'azure-client-id', variable: 'ARM_CLIENT_ID'),
          string(credentialsId: 'azure-client-secret', variable: 'ARM_CLIENT_SECRET'),
          string(credentialsId: 'azure-tenant-id', variable: 'ARM_TENANT_ID'),
          string(credentialsId: 'azure-subscription-id', variable: 'ARM_SUBSCRIPTION_ID')
        ]) {
          sh 'cd TF-Files && terraform apply -input=false -auto-approve tfplan'
        }
      }
    }

    stage('Show Outputs') {
      steps {
        sh 'cd TF-Files && terraform output'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'TF-Files/tfplan', allowEmptyArchive: true
      sh 'cd TF-Files && terraform show -no-color tfplan || true'
    }
  }
}
