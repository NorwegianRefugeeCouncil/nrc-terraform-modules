# Terraform Azure Infrastructure Deployment

## Overview

This repository automates the provisioning and management of Azure infrastructure using Terraform. It leverages GitHub Actions workflows to enable continuous deployment and infrastructure as code (IaC) practices. The workflows in this repository allow you to apply Terraform configurations automatically when changes are pushed to the repository.


## Table of Contents

- [Prerequisites](#prerequisites)
- [Folder Structure](#folder-structure)
- [Workflow Configuration](#workflow-configuration)
- [Usage](#usage)
- [Terraform Best Practices](#terraform-best-practices)
- [Contributing](#contributing)
- [License](#license)


## Prerequisites
Before using this repository, ensure you have the following prerequisites:

1. **Azure Subscription:** You should have access to an Azure subscription where you can create and manage resources.
2. **Azure Service Principal:** Create a service principal in Azure and obtain the necessary credentials (client ID, client secret, tenant ID). These will be used for authentication during Terraform deployments.
3. **GitHub Repository:** Fork or clone this repository into your GitHub account.
4. **GitHub Secrets:** Set up GitHub repository secrets to securely store your Azure service principal credentials. Refer to the [Workflow Configuration](#workflow-configuration) section for details.



## Folder Structure
- `.github/workflows/`: Contains GitHub Actions workflow files.
- `deploy/terraform/`: Contains Terraform configuration files and modules.
- `README.md`: This README file.


## Workflow Configuration
GitHub Actions workflows are defined in the `.github/workflows/` directory.


### GitHub Secrets
To securely store sensitive information, such as Azure service principal credentials, use GitHub repository secrets. The following secrets are required for the workflow:

- `AZURE_CREDENTIALS`: Azure service principal CREDENTIALS.
- `AZURE_AD_CLIENT_SECRET`: Azure service principal client secret.

And store the following variables along with the others:

- `INFRA_SUBSCRIPTION_ID`: Azure service principal client secret.
- `INFRA_AD_CLIENT_ID` : "your-client-id"
- `INFRA_AD_TENANT_ID` : "your-tenant-id"

### Other Terraform Variables


# Workflow Triggers

The workflow is triggered manually by selecting the environment from the dropdown. You can customize the trigger conditions in the workflow file to when changes are pushed to the `main` branch

### Deployment Targets

The workflow can be configured to deploy to one or more Azure environments (e.g., development, staging, production). Modify the workflow file to specify the deployment target.

## Usage

1. Fork or clone this repository into your GitHub account.

2. Configure the GitHub repository secrets mentioned in the [Workflow Configuration](#workflow-configuration) section.

3. Customize the Terraform configurations in the `terraform/` directory to match your infrastructure requirements. Update the variables and secrets.

4. Commit and push your changes to the repository. GitHub Actions will trigger the Terraform deployment workflow based on your configured trigger conditions.

## Terraform Best Practices

Follow Terraform best practices to maintain a clean and organized codebase:

- Organize your Terraform configurations into modules for reusability.
- Use version control to track changes to your infrastructure code.
- Avoid hardcoding sensitive credentials or secrets in your configurations.
- Document your configurations and provide clear README instructions.

