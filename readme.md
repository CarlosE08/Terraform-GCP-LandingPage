# Landing Page en GCP con Terraform

Este es un proyecto que utiliza un bucket de Cloud Storage para desplegar una página web, pero que cuenta con una vista protegida por CDN y que integra funciones de Cloud Load Balancing.

## Estructura del proyecto

```
forticus-landing/
│
├── dist/                    # Carpeta con archivos finales para el despliegue
│   ├── index.html
│   ├── error.html
│   └── assets/              # CSS, JS, imágenes
│
├── modules/
│   ├── Cloud_Load_Balancing.tf              # Módulo para el balanceo de carga
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── Cloud_Storage.tf                     # Módulo para recursos de Cloud Storage
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── main.tf              # Todo el código Terraform
├── variables.tf         # (opcional) Variables si lo haces modular
├── outputs.tf           # (opcional) Salidas como IP, URL
│
└── README.md
```

## Arquitectura de componentes


        [               Dominio                ]
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │     DNS A Record (No-IP o dominio)   │
        └──────────────────────────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │       IP Pública Global (GCP)        │
        └──────────────────────────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │    HTTPS Proxy con Certificado SSL   │
        └──────────────────────────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │       URL Map y Backend Bucket       │
        └──────────────────────────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │  Cloud Storage Bucket (hosting web)  │
        └──────────────────────────────────────┘

## Etiquetas del proyecto

Como parte de las buenas prácticas, este proyecto cuenta con un apartado para colocar etiquetas (labels en este caso), las cuales son:

```hcl
owner       = "Carlos Escobar"
customer    = "Forticus Tech"
project     = "Terraform_testing"
environment = "default"
```

Esta última dependerá del "workspace" actual de terraform, ya que esto nos ayudaría a separar los ambientes de una manera fácil, sin estar generando nuevos archivos de toda la infraestructura para cada uno. Estos workspaces se pueden alterar de la siguiente manera:


### Listar workspaces

```bash
terraform workspace list
```

---

### Cambiar de workspace a uno previamente creado

```bash
terraform workspace select nombre_de_tu_worspace
```

---

### Crear un nuevo workspace

```bash
terraform workspace new nombre_de_tu_worspace
```

---

## Requisitos Previos

- Tener una cuenta de GCP y un proyecto creado.
- Tener habilitada la API de los servicios que se van a usar (Compute Engine, Cloud Storage, etc.).
- Tener instalado:
  - [Terraform](https://www.terraform.io/downloads)
  - [gcloud CLI](https://cloud.google.com/sdk/docs/install)

---

## Instalación de Terraform

### En macOS (con Homebrew):

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### En Linux:

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform
```

### En Windows:

1. Descarga el binario desde [terraform.io/downloads](https://www.terraform.io/downloads).
2. Extrae el contenido y agrega la carpeta al `PATH` del sistema.

---

## Configuración de Credenciales en GCP

### Paso 1: Autenticarse con `gcloud`

```bash
gcloud auth login
```

### Paso 2: Establecer tu proyecto y región por defecto

```bash
gcloud config set project TU_ID_PROYECTO
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
```

### Paso 3: Generar el archivo de credenciales

```bash
gcloud iam service-accounts keys create credentials.json   --iam-account=TU_CUENTA_SA@TU_PROYECTO.iam.gserviceaccount.com
```

Asegúrate de que el service account tenga los permisos adecuados (por ejemplo, `Editor` o permisos personalizados).

### Paso 4: Establecer la variable de entorno `GOOGLE_APPLICATION_CREDENTIALS`

```bash
export GOOGLE_APPLICATION_CREDENTIALS="./credentials.json"
```

> Para mantener esta variable de entorno entre sesiones, puedes agregarla a tu `~/.bashrc`, `~/.zshrc` o equivalente.

---

## Flujo de Trabajo con Terraform

A continuación, se muestra el flujo típico para trabajar con este proyecto:

### 1. Inicializar el proyecto

```bash
terraform init
```

---

### 2. Formatear el código

```bash
terraform fmt
```

---

### 3. Validar la configuración

```bash
terraform validate
```

---

### 4. Previsualizar los cambios

```bash
terraform plan
```

---

### 5. Aplicar los cambios

```bash
terraform apply
```

O bien, para saltarnos la confirmación manual:

```bash
terraform apply -auto-approve
```

---

### 6. Destruir la infraestructura

```bash
terraform destroy
```

O bien, para saltarnos la confirmación manual:

```bash
terraform destroy -auto-approve
```

---