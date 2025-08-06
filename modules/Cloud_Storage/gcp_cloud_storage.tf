
######################
# 1. Storage Bucket
######################
resource "google_storage_bucket" "forticus_bucket" {
  name                        = var.bucket_name
  location                    = "US"
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

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  bucket = google_storage_bucket.forticus_bucket.name
  #content      = "# Forticus Landing en construcción"

  source       = "./dist/index.html" # Asegúrate de que el archivo index.html esté en la carpeta dist
  content_type = "text/html"
}

resource "google_storage_bucket_object" "error" {
  name   = "error.html"
  bucket = google_storage_bucket.forticus_bucket.name
  #content      = "# Forticus Landing en construcción"

  source       = "./dist/error.html" # Asegúrate de que el archivo index.html esté en la carpeta dist
  content_type = "text/html"
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