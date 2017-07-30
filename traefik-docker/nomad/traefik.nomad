job "lb" {  
  datacenters = ["dc1"]
  type = "service"

  task "traefik" {
    driver = "docker"

    config {
      image = "traefik:latest"
      
      labels {
        traefik.backend = "ui",
        traefik.enable = "true",
        traefik.frontend.rule = "Host:ui.docker.localhost"
      }

      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock",
        # "docker.endpoint:/var/run/docker.sock", # Doesn't work
        # If it's not running, check the absolute path
        "/Users/alextanhongpin/Documents/nodejs/full-stack-microservice/traefik-docker/nomad/conf/traefik.toml:/etc/traefik/traefik.toml" # Must use absolute path
      ]

      # If you are not planning to use the traefik.toml file, you can also define it here
      // args = [
      //   "--web", # Required to display the dashboard ui
      //   "--docker", # Use docker backend
      //   "--docker.domain=testing.localhost",
      //   "--docker.watch=true",
      //   "--logLevel=DEBUG"
      // ]

      port_map {
        admin    = 8080
        frontend = 80
      }
      
      dns_servers = ["${attr.unique.network.ip-address}"]
    }

    service {
      name = "traefik-admin"
      port = "admin"

      check {
        type     = "tcp"
        port     = "admin"
        interval = "10s"
        timeout  = "2s"
      }
    }

    service {
      name = "traefik-frontend"
      port = "frontend"

      check {
        type     = "tcp"
        port     = "frontend"
        interval = "10s"
        timeout  = "2s"
      }
    }

    resources {
      cpu    = 200
      memory = 200

      network {
        mbits = 50

        port "admin" {
        }

        port "frontend" {
          static = "80"
        }
      }
    }
  }


  group "whoamis_docker" {
    count = 3

    restart {
      attempts = 10
      interval = "1m"
      delay = "5s"
      mode = "delay"
    }

    ephemeral_disk {
      size = 500
    }

    task "backend" {
      driver = "docker"

      config {
          image = "emilevauge/whoami"
          labels {
            traefik.backend = "whoami",
            traefik.frontend.rule = "Host:whoami.docker.localhost",
            traefik.enable = "true",
            traefik.frontend.entryPoints = "http"
          }
      }

      service {
        name = "whoami"
        # Using Tags is incorrect
        // tags = [
        //     "traefik.backend=consul_whoami",
        //     "traefik.frontend.rule=Host:consul.localhost",
        //     "traefik.enable=true",
        //     "traefik.frontend.entryPoints=http",
        //     # "traefik.docker.network=nomad_docker"
        // ]
        // check {
        //   type     = "tcp"
        //   port     = "http"
        //   interval = "10s"
        //   timeout  = "2s"
        // }
        port = "http"
      }
      resources {
        cpu    = 200
        memory = 200
        network {
            mbits = 50
            port "http" {}
        }
      }
    }
  }
}