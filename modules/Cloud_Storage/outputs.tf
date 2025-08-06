output "backend_id" {
  value = google_compute_backend_bucket.forticus_backend.id
  description = "value of the backend bucket ID for the load balancer"
}

output "forticus_ip_id" {
  value = google_compute_global_address.forticus_ip.id
  description = "ID of the static IP address for the load balancer"
}

output "forticus_bucket_name" {
  value = google_storage_bucket.forticus_bucket.name
  description = "Name of the storage bucket"
}