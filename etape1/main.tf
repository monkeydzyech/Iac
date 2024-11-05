# Utiliser le provider Docker de kreuzwerker
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"  # Utilise une version valide
    }
  }
}

provider "docker" {}

# Créer un réseau Docker pour relier les conteneurs
resource "docker_network" "app_network" {
  name = "app_network"
}

# Télécharger l'image Nginx
resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}

# Télécharger l'image PHP-FPM
resource "docker_image" "php_image" {
  name         = "php:7.4-fpm"
  keep_locally = false
}

# Créer un conteneur pour Nginx
resource "docker_container" "nginx_container" {
  name  = "http"
  image = docker_image.nginx_image.latest
  networks_advanced {
    name = docker_network.app_network.name
  }
  ports {
    internal = 80
    external = 8080
  }
  # Monter le fichier de configuration Nginx avec un chemin absolu
  volumes {
    container_path = "/etc/nginx/nginx.conf"
    host_path      = abspath("${path.module}/nginx.conf")
  }
}

# Créer un conteneur pour PHP-FPM
resource "docker_container" "php_container" {
  name  = "script"
  image = docker_image.php_image.latest
  networks_advanced {
    name = docker_network.app_network.name
  }
  # Monter le répertoire de l'application PHP avec un chemin absolu
  volumes {
    container_path = "/app"
    host_path      = abspath("${path.module}/app")
  }
}
