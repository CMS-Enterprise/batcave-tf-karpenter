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

resource "helm_release" "karpenter" {
  namespace        = var.helm_namespace

  name       = "autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "autoscaler/cluster-autoscaler"
  version    = "9.16.2"

  set {
    name  = "controller.clusterName"
    value = var.cluster_name
  }
  set {
    name  = "autoscalingGroups[0].name"
    value = var.general_asg
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
    name  = "autoscalingGroups[0].name"
    value = var.runner_asg
  }
  set {
    name = "autoscalingGroups[0].min"
    value = "1"
  }
  set {
    name = "autoscalingGroups[0].max"
    value = "5"
  }

}

