
module "Cloud_Storage" {
  source      = "./modules/Cloud_Storage"
  bucket_name = var.bucket_name
  common_tags = var.common_tags
  region      = var.region
}

module "Cloud_Load_Balancing" {
  source         = "./modules/Cloud_Load_Balancing"
  common_tags    = var.common_tags
  backend_id     = module.Cloud_Storage.backend_id
  forticus_ip_id = module.Cloud_Storage.forticus_ip_id
  domain         = var.domain
}