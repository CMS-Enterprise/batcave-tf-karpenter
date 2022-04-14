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
    value = var.general_asg
  }
  set {
    name = "autoscalingGroups[0].minSize"
    value = var.general_asg_min
  }
  set {
    name = "autoscalingGroups[0].maxSize"
    value = var.general_asg_max
  }
  set {
    name  = "autoscalingGroups[1].name"
    value = var.runner_asg
  }
  set {
    name = "autoscalingGroups[1].minSize"
    value = var.runner_asg_min
  }
  set {
    name = "autoscalingGroups[1].maxSize"
    value = var.runner_asg_max
  }
  set {
    name = "resources.limits.cpu"
    value = "1"
  }
  set {
    name = "resources.limits.memory"
    value = "1Gi"
  }
  set {
    name = "resources.requests.cpu"
    value = "500mi"
  }
  set {
    name = "resources.requests.memory"
    value = "500m"
  }

}

