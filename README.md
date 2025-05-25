# AKS Store Operations

This repository contains the infrastructure as code and CI/CD pipelines to provision and manage an Azure Kubernetes Service (AKS) cluster for store operations.

## Directory Structure

- `.github/workflows/`: Contains GitHub Actions workflow files for CI/CD.
- `deploy/aks/`: Contains infrastructure as code (e.g., Terraform, ARM templates) for provisioning the AKS cluster and Helm charts for application deployment.
  - `deploy/aks/foundation/`: Contains base infrastructure components for the cluster.
    - `deploy/aks/foundation/flux/`: Contains files for deploying FluxCD components.
    - `deploy/aks/foundation/aks-store-demo/`: Contains files for deploying the aks-store-demo application using FluxCD.
  - `deploy/aks/terraform/`: Terraform code for AKS.
  - `deploy/aks/helm/simple-app/`: Helm chart for a simple application.

## Contributing

Please refer to CONTRIBUTING.md for details on how to contribute to this project.aaa
asd
