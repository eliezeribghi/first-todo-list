provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Assurez-vous que c'est le bon chemin
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  version    = "5.36.0"

  set {
    name  = "server.extraArgs"
    value = "--insecure"
  }
}