######################
# Outputs
######################

output "bucket_url" {
  value = "https://storage.googleapis.com/${module.Cloud_Storage.forticus_bucket_name}/index.html"
}

output "static_ip" {
  value = module.Cloud_Storage.forticus_ip_address
}

output "landing_page_url" {
  value = "https://${var.domain}"
}