###############################################################################
# Kubernetes provider configuration
###############################################################################

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

resource "kubernetes_manifest" "eniconfig_subnets" {

  for_each = var.vpc_eni_subnets

  depends_on = [
    helm_release.karpenter
  ]

  manifest = {
    "apiVersion" = "crd.k8s.amazonaws.com/v1alpha1"
    "kind"       = "ENIConfig"
    "metadata" = {
      "name" = each.key
    }
    "spec" = {
      "subnet" = "eni-${each.value}"
      "securityGroups" = [
        var.worker_security_group_id
      ]
    }
  }

}

resource "null_resource" "rotate_nodes_after_eniconfig_creation" {

  count = var.rotate_nodes_after_eniconfig_creation ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --filter "Name=tag:Name,Values=$CLUSTER_NAME-general" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].[InstanceId]" --output text) --output text
    EOT
  }

}
