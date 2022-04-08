################################################################################
# Helm Release - Karpenter
################################################################################
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
  create_namespace = var.helm_create_namespace

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "0.8.1"

  values = [
    "${file("values.yaml")}"
  ]
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_karpenter.iam_role_arn
  }

  set {
    name  = "controller.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "controller.clusterEndpoint"
    value = var.cluster_endpoint
  }
}