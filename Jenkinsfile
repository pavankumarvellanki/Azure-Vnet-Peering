pipeline {
  agent any

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
        sh "docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace hashicorp/terraform:1.5.7 terraform fmt -check -diff"
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
          sh "docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace -e ARM_CLIENT_ID=${ARM_CLIENT_ID} -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} -e ARM_TENANT_ID=${ARM_TENANT_ID} -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} hashicorp/terraform:1.5.7 terraform init -input=false"
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
          sh "docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace -e ARM_CLIENT_ID=${ARM_CLIENT_ID} -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} -e ARM_TENANT_ID=${ARM_TENANT_ID} -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} hashicorp/terraform:1.5.7 terraform validate"
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
          sh "docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace -e ARM_CLIENT_ID=${ARM_CLIENT_ID} -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} -e ARM_TENANT_ID=${ARM_TENANT_ID} -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} hashicorp/terraform:1.5.7 terraform plan -out=tfplan -input=false"
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
          sh "docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace -e ARM_CLIENT_ID=${ARM_CLIENT_ID} -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} -e ARM_TENANT_ID=${ARM_TENANT_ID} -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} hashicorp/terraform:1.5.7 terraform apply -input=false -auto-approve tfplan"
        }
      }
    }

    stage('Show Outputs') {
      steps {
        sh "docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace hashicorp/terraform:1.5.7 terraform output"
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'TF-Files/tfplan', allowEmptyArchive: true
      sh "docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace hashicorp/terraform:1.5.7 sh -c 'terraform show -no-color tfplan || true'"
    }
  }
}
