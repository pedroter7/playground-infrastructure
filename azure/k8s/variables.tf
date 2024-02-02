variable "k8s_cluster_host" {
  description = "Kubernetes cluster hostname"
  type        = string
}

variable "k8s_cluster_ca_cert" {
  description = "Kubernetes cluster CA cert base64 encoded"
  type        = string
}

variable "azure_tenant_id" {
  type = string
}

variable "aks_aad_id" {
  description = "AKS cluster Azure AD application ID"
  type        = string
}

variable "k8s_sp_id" {
  description = "Service principal ID to manage the Kubernetes cluster"
  type        = string
}

variable "k8s_sp_secret" {
  description = "Service principal secret to manage the Kubernetes cluster"
  type        = string
  sensitive   = true
}

variable "loadbalancer_ip" {
  description = "IP address to use for LoadBalancer ingress gateway"
  type        = string
}

variable "istio_node_madefor_label_value" {
  description = "Value of the label madefor that was used to label the node in which istio system should run"
  type        = string
}