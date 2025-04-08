provider "azurerm" {
  features {}
}
resource "azurerm_kubernetes_cluster" "aks" {

  name                = "aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aksterraform"
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = ["<YOUR_AAD_GROUP_ID>"]
  }
}

resource "null_resource" "auto_destroy" {
  triggers = { always_run = timestamp() }

  provisioner "local-exec" {
    command = <<EOT
      echo "terraform destroy -auto-approve" | at now + 12 hours
    EOT
  }
}