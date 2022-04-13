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
    default = "kube-system"
}

variable "helm_name" {
    default = "auto-scaler"
}

variable "general_asg" {}
variable "runner_asg" {}

variable "general_asg_min" {
  default = "1"
}

variable "general_asg_max" {
  default = "5"
}

variable "runner_asg_min" {
  default = "0"
}

variable "runner_asg_max" {
  default = "5"
}
