# AKS Store Operations

This repository contains the infrastructure as code and CI/CD pipelines to provision and manage an Azure Kubernetes Service (AKS) cluster for store operations.

## Helm Chart

The Helm chart for the store application is located in the `helm/store-app` directory.

### Prerequisites

- Kubernetes cluster (e.g., AKS, Minikube)
- Helm 3 installed
- Kubectl configured to connect to your cluster

### Installation

To install the Helm chart, use the following command:

```bash
helm install <release-name> ./helm/store-app --namespace <target-namespace>
```

Replace `<release-name>` with a name for your release (e.g., `my-store`) and `<target-namespace>` with the namespace where you want to deploy the application.

You can customize the installation by overriding values in the `values.yaml` file. For example:

```bash
helm install <release-name> ./helm/store-app --namespace <target-namespace> --set storeFront.replicaCount=2
```

Or by providing a custom values file:

```bash
helm install <release-name> ./helm/store-app --namespace <target-namespace> -f my-custom-values.yaml
```

## CI/CD Workflows

This repository uses GitHub Actions for CI/CD. The workflows are defined in the `.github/workflows/` directory.

- **`build-docker-image.yaml`**: This workflow builds the Docker image for the application. It can be triggered manually or by a `repository_dispatch` event (e.g., when the application source code is updated). It builds the image, tags it (e.g., with an epoch timestamp), and pushes it to a Docker registry. It then updates the image tag in the HelmRelease manifest (`deploy/aks/foundation/aks-store-demo/store-app-release.yaml`) and commits the change to the ops repository.

- **`update-app-image.yaml`**: (Assuming this workflow exists as it was previously mentioned or intended) This workflow is typically triggered by a `repository_dispatch` event when a new application image is available. It updates the image tag in the HelmRelease manifest (`deploy/aks/foundation/aks-store-demo/store-app-release.yaml`) to use the new image and commits the change.

## Contributing

Please refer to CONTRIBUTING.md for details on how to contribute to this project.aaa
