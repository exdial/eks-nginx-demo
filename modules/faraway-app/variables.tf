variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "cluster_version" {
  type        = string
  description = "Cluster version"
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
}

variable "aws_profile" {
  type = string
  description = "AWS profile"
}

variable "kubeconfig" {
  type        = string
  description = "Kubeconfig"
  default     = "~/.kube/config"
}

variable "registry_server" {
  type        = string
  description = "Docker registry server"
  default     = "registry.hub.docker.com"
}

variable "registry_username" {
  type        = string
  description = "Docker registry username"
}

variable "registry_password" {
  type        = string
  description = "Docker registry password"
}

variable "registry_email" {
  type        = string
  description = "Docker registry email"
  default     = "user@email.tld"
}

variable "helm_nginx" {
  description = "The helm release configuration"
  default = {
    values = {
      "ingress.enabled"          = "true"
      "imagePullPolicy"          = "Always"
      "autoscaling.enabled"      = "true"
      "autoscaling.minReplicas"  = "2"
      "autoscaling.maxReplicas"  = "10"
      "autoscaling.targetCPU"    = "30"
      "service.type"             = "LoadBalancer"
      "image.PullSecrets"        = "registrycreds"
      "ingress.ingressClassName" = "nginx"
      "ingress.IngressClass"     = "nginx"
    }
  }
}
