resource "kubernetes_namespace" "istio_system" {
  metadata {
    labels = {
      madefor         = var.istio_node_madefor_label_value
      istio-injection = "enabled"
    }

    name = local.istio_ns
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = local.istio_charts_repo
  chart      = "base"
  version    = local.istio_charts_version
  namespace  = local.istio_ns

  set {
    name  = "global.istioNamespace"
    value = local.istio_ns
  }

  depends_on = [
    kubernetes_namespace.istio_system
  ]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = local.istio_charts_repo
  chart      = "istiod"
  version    = local.istio_charts_version
  namespace  = local.istio_ns

  set {
    name  = "pilot.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "pilot.resources.requests.memory"
    value = "512Mi"
  }

  set {
    name  = "pilot.resources.limits.memory"
    value = "1536Mi"
  }

  set {
    name  = "pilot.nodeSelector.madefor"
    value = var.istio_node_madefor_label_value
  }

  set {
    name  = "global.istioNamespace"
    value = local.istio_ns
  }

  set {
    name  = "istio_cni.enabled"
    value = "true"
  }

  set {
    name  = "istio_cni.chained"
    value = "true"
  }

  depends_on = [
    helm_release.istio_base
  ]
}

resource "kubernetes_namespace" "istio_gateway" {
  metadata {
    labels = {
      madefor         = var.istio_node_madefor_label_value
      istio-injection = "enabled"
    }

    name = local.istio_ing_ns
  }
}

resource "helm_release" "istio_cni" {
  name       = "istio-cni"
  repository = local.istio_charts_repo
  chart      = "cni"
  version    = local.istio_charts_version
  namespace  = local.istio_ns

  set_list {
    name  = "cni.excludeNamespaces"
    value = ["kube-system", local.istio_ns]
  }

  depends_on = [
    helm_release.istiod,
  ]
}

resource "helm_release" "istio_gateway" {
  name       = "istio-gateway"
  repository = local.istio_charts_repo
  chart      = "gateway"
  version    = local.istio_charts_version
  namespace  = local.istio_ing_ns

  set {
    name  = "service.loadBalancerIP"
    value = var.loadbalancer_ip
  }

  set {
    name  = "labels.istio"
    value = local.istio_gateway_pod_label
  }

  set {
    name  = "nodeSelector.madefor"
    value = var.istio_node_madefor_label_value
  }

  depends_on = [
    helm_release.istio_cni,
    kubernetes_namespace.istio_gateway
  ]
}