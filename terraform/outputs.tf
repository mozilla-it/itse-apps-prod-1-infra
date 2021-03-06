output "cluster_id" {
  value = module.itse-apps-prod-1.cluster_id
}

output "cluster_oidc_issuer_url" {
  value = module.itse-apps-prod-1.cluster_oidc_issuer_url
}

output "cluster_name" {
  value = module.itse-apps-prod-1.cluster_id
}

output "refractr_eip_allocation_id" {
  value = aws_eip.refractr_eip.*.id
}

output "refractr_ips" {
  value = aws_eip.refractr_eip.*.public_ip
}
