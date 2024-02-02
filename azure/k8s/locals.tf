locals {
  istio_ns                = "istio-system"
  istio_ing_ns            = "istio-ingressgateway"
  istio_gateway_pod_label = "istio-ingressgateway"
  istio_charts_version    = "1.20.2"
  istio_charts_repo       = "https://istio-release.storage.googleapis.com/charts"
}