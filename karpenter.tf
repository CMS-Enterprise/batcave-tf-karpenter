data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "autoscaler" {
  namespace        = var.helm_namespace

  name       = "autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  set {
    name  = "controller.clusterName"
    value = var.cluster_name
  }
  set {
    name  = "autoscalingGroups[0].name"
    value = "batcave-east-dev-general-20220413231326161600000017"
  }
  set {
    name = "autoscalingGroups[0].min"
    value = "1"
  }
  set {
    name = "autoscalingGroups[0].max"
    value = "5"
  }
  set {
    name = "resources.limits.cpu"
    value = "2"
  }
  set {
    name = "resources.limits.memory"
    value = "2Gi"
  }
  set {
    name = "resources.requests.cpu"
    value = "1"
  }
  set {
    name = "resources.request.memory"
    value = "1Gi"
  }
  set {
    name = "extraEnv[0]"
    value = "AWS_REGION=us-east-1"
  }

}

