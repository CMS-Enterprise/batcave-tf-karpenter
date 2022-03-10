output "karpenter_iam" {
  value = aws_iam_instance_profile.karpenter.id
}

output "hr_manifest" {
  description = "The rendered manifest of the release as JSON"
  value = helm_release.karpenter
  sensitive = true
}

