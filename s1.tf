# Reference:  https://learn.hashicorp.com/tutorials/terraform/helm-provider?in=terraform/kubernetes

data "google_client_config" "default" {}

provider "helm" {
  kubernetes {
    host  = google_container_cluster.primary.endpoint
    token = data.google_client_config.default.access_token
    client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
    client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

resource "kubernetes_namespace" "s1" {
  metadata {
    name = var.s1_namespace
  }
  depends_on = [google_container_node_pool.primary_nodes]
}

locals {
  dockerconfigjson = {
    "auths" = {
      (var.docker_server) = {
        username = var.docker_username
        password = var.docker_password
        auth     = base64encode(join(":", [var.docker_username, var.docker_password]))
      }
    }
  }
}

resource "kubernetes_secret" "s1" {
  metadata {
    name      = var.s1_repository_pull_secret_name
    namespace = var.s1_namespace
  }
  data = {
    ".dockerconfigjson" = jsonencode(local.dockerconfigjson)
  }
  type       = "kubernetes.io/dockerconfigjson"
  depends_on = [kubernetes_namespace.s1]
}

resource "helm_release" "sentinelone" {
  name       = var.helm_release_name
  repository = "https://charts.sentinelone.com"
  chart      = "s1-agent"
  version    = var.helm_chart_version
  namespace  = kubernetes_namespace.s1.metadata[0].name
  set {
    name  = "secrets.imagePullSecret"
    value = var.s1_repository_pull_secret_name
  }
  set {
    name  = "configuration.repositories.helper"
    value = var.s1_helper_image_repository
  }
  set {
    name  = "configuration.tag.helper"
    value = var.s1_helper_image_tag
  }
  set {
    name  = "configuration.cluster.name"
    value = var.cluster_name
  }
  set {
    name  = "configuration.repositories.agent"
    value = var.s1_agent_image_repository
  }
  set {
    name  = "configuration.tag.agent"
    value = var.s1_agent_image_tag
  }
  set {
    name  = "secrets.site_key.value"
    value = var.s1_site_key
  }
  set {
    name  = "helper.nodeSelector\\.kubernetes.io/os'"
    value = "linux"
  }
  set {
    name  = "agent.nodeSelector\\.kubernetes.io/os'"
    value = "linux"
  }
  set {
    name  = "agent.resources.limits.cpu"
    value = var.agent_resources_limits_cpu
  }
  set {
    name  = "agent.resources.limits.memory"
    value = var.agent_resources_limits_memory
  }
  set {
    name  = "helper.resources.limits.cpu"
    value = var.helper_resources_limits_cpu
  }
  set {
    name  = "helper.resources.limits.memory"
    value = var.helper_resources_limits_memory
  }


  set {
    name  = "agent.resources.requests.cpu"
    value = var.agent_resources_requests_cpu
  }
  set {
    name  = "agent.resources.requests.memory"
    value = var.agent_resources_requests_memory
  }
  set {
    name  = "helper.resources.requests.cpu"
    value = var.helper_resources_requests_cpu
  }
  set {
    name  = "helper.resources.requests.memory"
    value = var.helper_resources_requests_memory
  }

  depends_on = [kubernetes_namespace.s1, kubernetes_secret.s1]
}