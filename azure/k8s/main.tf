terraform {
  required_version = ">= 1.1.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.25.2"
    }
  }
  cloud {
    workspaces {
      name    = "kubernetes"
      project = "azure"
    }
  }
}

provider "kubernetes" {
  host                   = var.k8s_cluster_host
  cluster_ca_certificate = base64decode(var.k8s_cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "./bin/kubelogin"
    args = [
      "get-token",
      "--login",
      "spn",
      "--environment",
      "AzurePublicCloud",
      "--tenant-id",
      var.azure_tenant_id,
      "--server-id",
      var.aks_aad_id,
      "--client-id",
      var.k8s_sp_id,
      "--client-secret",
      var.k8s_sp_secret
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.k8s_cluster_host
    cluster_ca_certificate = base64decode(var.k8s_cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "./bin/kubelogin"
      args = [
        "get-token",
        "--login",
        "spn",
        "--environment",
        "AzurePublicCloud",
        "--tenant-id",
        var.azure_tenant_id,
        "--server-id",
        var.aks_aad_id,
        "--client-id",
        var.k8s_sp_id,
        "--client-secret",
        var.k8s_sp_secret
      ]
    }
  }
}