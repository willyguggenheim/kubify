data "azurerm_resource_group" "rg" {
  name = "${var.cluster_name}-${var.aks_region}"
}

resource "random_string" "main" {
  length  = 8
  special = false
  upper   = false
}

#tfsec:ignore:azure-container-use-rbac-permissions
resource "azurerm_kubernetes_cluster" "aks" {
  # ignore node_count in case we are using AutoScaling
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      default_node_pool[0].tags
    ]
  }

  name                = var.name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  # Valid fields are:
  # * vm_size
  # * availability_zones
  # * enable_auto_scaling
  # * enable_host_encryption
  # * enable_node_public_ip
  # * eviction_policy
  # * max_pods
  # * mode
  # * node_labels
  # * node_taints
  # * orchestrator_version
  # * os_disk_size_gb
  # * os_disk_type
  # * os_type
  # * priority
  # * spot_max_price
  # * tags
  # * max_count
  # * min_count
  # * node_count
  # * max_surge
  default_node_pool {
    name                         = var.default_pool_name
    vm_size                      = var.vm_size
    enable_auto_scaling          = var.enable_auto_scaling
    enable_host_encryption       = var.enable_host_encryption
    enable_node_public_ip        = var.enable_node_public_ip
    max_pods                     = var.max_pods
    node_labels                  = var.node_labels
    only_critical_addons_enabled = var.only_critical_addons_enabled
    orchestrator_version         = var.orchestrator_version
    os_disk_size_gb              = var.os_disk_size_gb
    os_disk_type                 = var.os_disk_type
    type                         = var.agent_type
    vnet_subnet_id               = var.vnet_subnet_id
    # spot_max_price               = var.spot_max_price

    max_count  = var.enable_auto_scaling == true ? var.max_count : null
    min_count  = var.enable_auto_scaling == true ? var.min_count : null
    node_count = var.node_count

    dynamic "upgrade_settings" {
      for_each = var.max_surge == null ? [] : ["upgrade_settings"]
      content {
        max_surge = var.max_surge
      }
    }

    tags = var.agent_tags
  }

  identity {
    type = var.user_assigned_identity_id == "" ? "SystemAssigned" : "UserAssigned"
    # user_assigned_identity_id = var.user_assigned_identity_id == "" ? null : var.user_assigned_identity_id
  }


  aci_connector_linux {
    subnet_name = var.enable_aci_connector_linux ? var.aci_connector_linux_subnet_name : null
  }

  azure_policy_enabled = true

  http_application_routing_enabled = true

  # kube_dashboard {
  #   enabled = var.enabled_kube_dashboard
  # }

  oms_agent {
    log_analytics_workspace_id = var.enable_log_analytics_workspace ? azurerm_log_analytics_workspace.main[0].id : null
  }


  # role_based_access_control_enabled = true

  # azure_active_directory_role_based_access_control {

  #   dynamic "azure_active_directory" {
  #     for_each = var.enable_role_based_access_control && var.enable_azure_active_directory && var.rbac_aad_managed ? ["rbac"] : []
  #     content {
  #       managed                = true
  #       admin_group_object_ids = var.rbac_aad_admin_group_object_ids
  #     }
  #   }

  #   dynamic "azure_active_directory" {
  #     for_each = var.enable_role_based_access_control && var.enable_azure_active_directory && !var.rbac_aad_managed ? ["rbac"] : []
  #     content {
  #       managed           = false
  #       client_app_id     = var.rbac_aad_client_app_id
  #       server_app_id     = var.rbac_aad_server_app_id
  #       server_app_secret = var.rbac_aad_server_app_secret
  #     }
  #   }
  # }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    outbound_type      = var.outbound_type
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
    load_balancer_sku  = var.load_balancer_sku
  }

  automatic_channel_upgrade       = var.automatic_channel_upgrade
  kubernetes_version              = var.kubernetes_version
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  disk_encryption_set_id          = var.disk_encryption_set_id
  private_cluster_enabled         = var.private_cluster_enabled
  private_dns_zone_id             = var.private_dns_zone_id
  node_resource_group             = var.node_resource_group
  sku_tier                        = var.sku_tier

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  count = var.enable_log_analytics_workspace ? 1 : 0

  name                = "${var.dns_prefix}-workspace-${random_string.main.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "main" {
  count = var.enable_log_analytics_workspace ? 1 : 0

  solution_name         = "ContainerInsights"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.main[0].id
  workspace_name        = azurerm_log_analytics_workspace.main[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

module "node-pools" {
  source = "./modules/node-pools"

  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = var.vnet_subnet_id

  node_pools = var.node_pools
}

resource "azurerm_role_assignment" "attach_acr" {
  count = var.enable_attach_acr ? 1 : 0

  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks" {
  count = var.enable_log_analytics_workspace ? 1 : 0

  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.aks.oms_agent[0].oms_agent_identity[0].object_id
}
