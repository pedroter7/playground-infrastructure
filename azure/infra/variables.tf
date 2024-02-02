variable "region" {
  description = "Azure region to create resources"
  type        = string
  default     = "eastus"
}

variable "kubernetes_version" {
  type    = string
  default = "1.27.7"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for Kubernetes cluster"
  type        = string
  default     = "playground"
}

variable "prefix" {
  description = "A prefix used for all created resources"
  type        = string
  default     = "playground"
}

variable "aks_admin_sp_name" {
  description = "Name of the service provider to be created to admin the AKS cluster"
  type        = string
  default     = "terraform-aks-admin"
}

variable "extra_aks_admin_groups" {
  description = "IDs of groups in Azure AD to use as AKS cluster admins"
  type        = list(string)
  default     = []
}