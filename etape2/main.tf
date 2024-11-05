terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {}


resource "docker_network" "app_network" {
  name = "app_network"
}

resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}


resource "docker_image" "php_image" {
  name         = "custom-php:7.4"
  build {
    context    = "${path.module}"
    dockerfile = "Dockerfile"
  }
  keep_locally = false
}


resource "docker_image" "db_image" {
  name         = "mariadb:latest"
  keep_locally = false
}


resource "docker_container" "nginx_container" {
  name  = "http"
  image = docker_image.nginx_image.name
  networks_advanced {
    name = docker_network.app_network.name
  }
  ports {
    internal = 80
    external = 8080
  }
  volumes {
    container_path = "/etc/nginx/nginx.conf"
    host_path      = abspath("${path.module}/nginx.conf")
  }
  volumes {
    container_path = "/app"
    host_path      = abspath("${path.module}/app")
  }
}


resource "docker_container" "php_container" {
  name  = "script"
  image = docker_image.php_image.name
  networks_advanced {
    name = docker_network.app_network.name
  }
  volumes {
    container_path = "/app"
    host_path      = abspath("${path.module}/app")
  }
}


resource "docker_container" "db_container" {
  name  = "data"
  image = docker_image.db_image.name
  env = [
    "MYSQL_ROOT_PASSWORD=example",
    "MYSQL_DATABASE=test_db"
  ]
  networks_advanced {
    name = docker_network.app_network.name
  }
  ports {
    internal = 3306
    external = 3308
  }
}
