resource "azurerm_resource_group" "example" {
  name     = var.cluster_name
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = var.functions
  resource_group_name      = var.cluster_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  count                    = "${var.functions ? 1 : 0}"
}

resource "azurerm_app_service_plan" "example" {
  name                = var.functions
  location            = var.location
  resource_group_name = var.cluster_name
  kind                = "Linux"
  reserved            = true
  count               = "${var.functions ? 1 : 0}"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "kubify_functions" {
  name                       = "test-azure-functions"
  location                   = var.location
  resource_group_name        = var.cluster_name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  os_type                    = "linux"
  count                      = "${var.functions ? 1 : 0}"
}
