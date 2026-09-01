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
        sh '''
            if command -v docker >/dev/null 2>&1; then
                docker run --rm \
                    -v "${WORKSPACE}/TF-Files:/workspace" \
                    -w /workspace \
                    hashicorp/terraform:1.5.7 \
                    fmt -check -diff
            else
                terraform -chdir="${WORKSPACE}/TF-Files" fmt -check -diff
            fi
        '''
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
          sh '''if command -v docker >/dev/null 2>&1; then
        docker run --rm \
          -v "${WORKSPACE}/TF-Files:/workspace" \
          -w /workspace \
          -e ARM_CLIENT_ID \
          -e ARM_CLIENT_SECRET \
          -e ARM_TENANT_ID \
          -e ARM_SUBSCRIPTION_ID \
          hashicorp/terraform:1.5.7 \
          init -input=false
    else
        terraform -chdir="${WORKSPACE}/TF-Files" init -input=false
    fi'''
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
            sh '''
                if command -v docker >/dev/null 2>&1; then
                    docker run --rm \
                        -v "${WORKSPACE}/TF-Files:/workspace" \
                        -w /workspace \
                        -e ARM_CLIENT_ID \
                        -e ARM_CLIENT_SECRET \
                        -e ARM_TENANT_ID \
                        -e ARM_SUBSCRIPTION_ID \
                        hashicorp/terraform:1.5.7 \
                        validate
                else
                    terraform -chdir="${WORKSPACE}/TF-Files" validate
                fi
            '''
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
          sh "if command -v docker >/dev/null 2>&1; then docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace -e ARM_CLIENT_ID=${ARM_CLIENT_ID} -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} -e ARM_TENANT_ID=${ARM_TENANT_ID} -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} hashicorp/terraform:1.5.7 terraform plan -out=tfplan -input=false; else ARM_CLIENT_ID='${ARM_CLIENT_ID}' ARM_CLIENT_SECRET='${ARM_CLIENT_SECRET}' ARM_TENANT_ID='${ARM_TENANT_ID}' ARM_SUBSCRIPTION_ID='${ARM_SUBSCRIPTION_ID}' terraform -chdir=${WORKSPACE}/TF-Files plan -out=tfplan -input=false; fi"
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
          sh "if command -v docker >/dev/null 2>&1; then docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace -e ARM_CLIENT_ID=${ARM_CLIENT_ID} -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} -e ARM_TENANT_ID=${ARM_TENANT_ID} -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} hashicorp/terraform:1.5.7 terraform apply -input=false -auto-approve tfplan; else ARM_CLIENT_ID='${ARM_CLIENT_ID}' ARM_CLIENT_SECRET='${ARM_CLIENT_SECRET}' ARM_TENANT_ID='${ARM_TENANT_ID}' ARM_SUBSCRIPTION_ID='${ARM_SUBSCRIPTION_ID}' terraform -chdir=${WORKSPACE}/TF-Files apply -input=false -auto-approve tfplan; fi"
        }
      }
    }

    stage('Show Outputs') {
      steps {
        sh "if command -v docker >/dev/null 2>&1; then docker run --rm -v ${WORKSPACE}/TF-Files:/workspace -w /workspace hashicorp/terraform:1.5.7 terraform output; else terraform -chdir=${WORKSPACE}/TF-Files output; fi"
      }
    }
  
  }
  post {
    always {
        archiveArtifacts artifacts: 'TF-Files/tfplan', allowEmptyArchive: true

        sh '''
            if command -v docker >/dev/null 2>&1; then
                docker run --rm \
                    -v "${WORKSPACE}/TF-Files:/workspace" \
                    -w /workspace \
                    hashicorp/terraform:1.5.7 \
                    show -no-color tfplan || true
            else
                terraform -chdir="${WORKSPACE}/TF-Files" show -no-color tfplan || true
            fi
        '''
      }
    }
}
