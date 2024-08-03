provider "kubernetes" {
  config_path = "${var.kubeconfig}"
}

provider "helm" {
  kubernetes {
    config_path = "${var.kubeconfig}"
  }
}

resource "kubernetes_secret" "registrycreds" {
  metadata {
    name = "docker-cfg"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          "username" = var.registry_username
          "password" = var.registry_password
          "email"    = var.registry_email
          "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }
}

resource "helm_release" "nginx_ingress" {
  repository      = "https://kubernetes.github.io/ingress-nginx"
  name            = "ingress-nginx"
  chart           = "ingress-nginx"
  version         = null
  namespace       = "kube-system"
  wait            = true
  timeout         = 600
  cleanup_on_fail = true
  depends_on      = [ 
    module.eks,
    kubernetes_secret.registrycreds
  ]
}

resource "helm_release" "nginx" {
  repository      = "https://charts.bitnami.com/bitnami"
  name            = "nginx"
  chart           = "nginx"
  version         = null
  namespace       = "default"
  wait            = true
  timeout         = 600
  cleanup_on_fail = true
  depends_on      = [ 
    module.eks,
    kubernetes_secret.registrycreds
  ]

  dynamic "set" {
    for_each = merge({}, lookup(var.helm_nginx, "values", {}))
    content {
      name  = set.key
      value = set.value
    }
  }
}
