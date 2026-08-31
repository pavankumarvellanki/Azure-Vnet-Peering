# CI/CD for Terraform

This Jenkins pipeline deploys the Terraform configuration located in the `TF-Files` folder.

Required Jenkins credentials (create in Jenkins Credentials):

- `azure-client-id` (Secret text) — Azure Service Principal client id
- `azure-client-secret` (Secret text) — Azure Service Principal client secret
- `azure-tenant-id` (Secret text)
- `azure-subscription-id` (Secret text)

Pipeline behavior

- Runs `terraform fmt -check` to ensure formatting.
- Runs `terraform init` and `terraform validate`.
- Runs `terraform plan` on all branches and saves plan artifact.
- Runs `terraform apply` only when the branch is `main`.

Setup

1. Add the required credentials in Jenkins.
2. Create a Pipeline job and set the Pipeline script path to `CI-CD/Jenkinsfile`.
3. Ensure the Jenkins agent can run Docker and access the registry to pull the Terraform image.

Usage tips

- To test locally, run these commands from the repository root:

```bash
cd TF-Files
terraform init
terraform plan -out=tfplan
terraform show -no-color tfplan
```
