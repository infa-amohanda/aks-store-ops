# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Reference the existing resource group
data "azurerm_resource_group" "existing" {
  name = "aksdemo-rg" # Replace with your resource group name
}

# Reference the existing VNet
data "azurerm_virtual_network" "existing" {
  name                = "aksdemo-vnet" # Replace with your VNet name
  resource_group_name = data.azurerm_resource_group.existing.name
}

# Reference the existing subnet
data "azurerm_subnet" "existing" {
  name                 = "aksdemo-aks-subnet" # Replace with your subnet name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = data.azurerm_resource_group.existing.name
}

# Create the AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aksdemo-aks-cluster" # Replace with your desired cluster name
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  dns_prefix          = "aksdemocluster"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_D2_v2"
    min_count           = 1
    max_count           = 3
    vnet_subnet_id      = data.azurerm_subnet.existing.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  tags = {
    Environment = "Production"
  }
}

# Output the AKS cluster name and kubeconfig
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}