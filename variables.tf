variable "cluster_name" {}
variable "provider_url" {
  default = ""
}


### Karpenter IAM variables

variable "worker_iam_role_name" {
  default = ""
}

variable "iam_path" {
  default = "/delegatedadmin/developer/"
}

variable "permissions_boundary" {
  default = "arn:aws:iam::373346310182:policy/cms-cloud-admin/developer-boundary-policy"
}


### Helm variables

variable "helm_namespace" {
  default = "karpenter"
}
variable "helm_create_namespace" {
  type = bool
  default = true
}
variable "helm_name" {
  default = "karpenter"
}
variable "cluster_endpoint" {
  default = ""
}

variable "vpc_eni_subnets" {
  type = map(any)
}

variable "worker_security_group_id" {
  type = string
}

variable "rotate_nodes_after_eniconfig_creation" {
  type = bool
  default = true
}
