variable "cluster_name" {
  type = string
}
variable "provider_url" {
  default = ""
  type    = string
}


### Karpenter IAM variables

variable "worker_iam_role_name" {
  type = string
}

variable "iam_path" {
  default = "/delegatedadmin/developer/"
  type    = string
}

variable "permissions_boundary" {
  default = "arn:aws:iam::373346310182:policy/cms-cloud-admin/developer-boundary-policy"
  type    = string
}


### Helm variables

variable "helm_namespace" {
  default = "karpenter"
  type    = string
}
variable "helm_create_namespace" {
  type    = bool
  default = true
}
variable "cluster_endpoint" {
  default = ""
  type    = string
}

variable "vpc_eni_subnets" {
  type = map(any)
}

variable "worker_security_group_id" {
  type = string
}

variable "rotate_nodes_after_eniconfig_creation" {
  type    = bool
  default = true
}
