# Configure the Azure provider


data "azurerm_resource_group" "rg" {
  name     = "RCOS-Cilium_group"
}

resource "azurerm_virtual_network" "vnet"{
    name = "testVnet"
    address_space = ["10.0.0.0/16"]
    location = "eastus"
        resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_kubernetes_cluster" "default" {
    name = "test-aks"
    location = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    dns_prefix = "test-k8s"
    kubernetes_version = "1.29.4"
    default_node_pool{
        name = "default"
        node_count = 1
        vm_size = "Standard_A2_v2"
        os_disk_size_gb = 30
    }
    service_principal{
        client_id = var.CLIENT_ID
        client_secret = var.CLIENT_SECRET
    }
    role_based_access_control_enabled = true
    tags = {
        environment = "Demo"
    }
}
