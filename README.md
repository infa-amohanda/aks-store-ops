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

## GitOps with FluxCD

This repository uses FluxCD to implement GitOps, continuously synchronizing the state of your Kubernetes cluster with the configurations defined in this Git repository.

### FluxCD Components

The core FluxCD components are typically bootstrapped into your cluster. The manifests for setting up Flux can be found in `deploy/aks/foundation/flux-system/`:

- **`gotk-components.yaml`**: Defines the CustomResourceDefinitions (CRDs) and deployments for the FluxCD controllers (e.g., source-controller, kustomize-controller, helm-controller).
- **`gotk-sync.yaml`**: Configures the `GitRepository` source and the `Kustomization` that tells Flux to synchronize the cluster with the contents of this repository, specifically looking at the `deploy/aks/foundation/` path.
- **`kustomization.yaml`**: The top-level Kustomization for Flux, often pointing to other Kustomizations or resources to apply, including the HelmRelease for the application.

### Application Deployment via HelmRelease

The store application itself is deployed and managed by Flux using a `HelmRelease` resource.

- **`deploy/aks/foundation/aks-store-demo/store-app-release.yaml`**: This manifest defines the `HelmRelease` for the `store-app`. FluxCD's helm-controller monitors this resource. When changes are made to this file (e.g., updating the image tag via the `build-docker-image.yaml` workflow) or to the Helm chart itself, Flux will automatically apply the changes to your cluster, ensuring the deployed application matches the desired state defined in Git.

This GitOps approach allows for automated and auditable deployments, rollbacks, and management of your application and cluster configuration.
