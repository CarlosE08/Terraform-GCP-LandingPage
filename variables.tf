# Nombre del proyecto de Google Cloud Platform
variable "project" {}

# Región de Google Cloud Platform donde se desplegarán los recursos
variable "region" {}

# Nombre del bucket de Cloud Storage
variable "bucket_name" {}

# Dominio para la Landing Page
variable "domain" {}

# Etiquetas comunes para todos los recursos, en GCP llamadas "labels"
variable "common_tags" {
  description = "Etiquetas comunes para todos los recursos"
  type = object({
    owner    = string
    customer = string
    project  = string
  })
  default = {
    owner    = "carlos-escobar"
    customer = "forticus-tech"
    project  = "terraform_testing"
  }
}