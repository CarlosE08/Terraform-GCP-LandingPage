
######################
# 1. Storage Bucket
######################
resource "google_storage_bucket" "forticus_bucket" {
  name                        = var.bucket_name
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }

  labels = merge(var.common_tags, {
    environment = "${terraform.workspace}"
  })
}

resource "google_storage_bucket_object" "static_assets" {
  for_each = fileset("dist", "**") # Esto incluye todos los archivos dentro de dist y subdirectorios

  name        = each.value
  bucket      = google_storage_bucket.forticus_bucket.name
  source      = "dist/${each.value}"
  content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}


######################
# 2. IP Global
######################
resource "google_compute_global_address" "forticus_ip" {
  name = "forticus-ip"

  labels = merge(var.common_tags, {
    environment = "${terraform.workspace}"
  })
}

######################
# 3. Backend Bucket
######################
resource "google_compute_backend_bucket" "forticus_backend" {
  name        = "forticus-backend"
  bucket_name = google_storage_bucket.forticus_bucket.name
  enable_cdn  = true
}