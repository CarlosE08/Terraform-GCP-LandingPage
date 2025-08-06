
######################
# 4. Certificado SSL
######################
resource "google_compute_managed_ssl_certificate" "forticus_cert" {
  name = "forticus-cert"

  managed {
    domains = ["landing-forticus.ddns.net"] # Asegúrate de usar tu dominio No-IP aquí
  }
}

######################
# 5. URL Map
######################
resource "google_compute_url_map" "forticus_url_map" {
  name            = "forticus-url-map"
  default_service = var.backend_id
}

######################
# 6. HTTPS Proxy
######################
resource "google_compute_target_https_proxy" "forticus_https_proxy" {
  name             = "forticus-proxy"
  url_map          = google_compute_url_map.forticus_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.forticus_cert.id]
}

######################
# 7. Forwarding Rule
######################
resource "google_compute_global_forwarding_rule" "forticus_https_rule" {
  name                  = "forticus-https-rule"
  target                = google_compute_target_https_proxy.forticus_https_proxy.id
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  ip_address            = var.forticus_ip_id

  labels = merge(var.common_tags, {
    environment = "${terraform.workspace}"
  })
}
