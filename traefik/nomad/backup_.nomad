job "lb" {  
  datacenters = ["dc1"]
  type = "service"

  task "traefik" {
    driver = "docker"

    config {
      image = "traefik:1.3.4"

      volumes = [
        # "/var/run/docker.sock:/var/run/docker.sock",
        "${PWD}/conf:/etc/traefik"
      ]

      // args = [
      //   "--web",
      //   "--docker",
      //   "--docker.domain=testing.localhost",
      //   "--logLevel=DEBUG"
      // ]

      port_map {
        admin    = 8080
        frontend = 80
      }

      # dns_servers = ["${NOMAD_IP_admin}"]
      dns_servers = ["${attr.unique.network.ip-address}"]
    }

    // service {
    //   name = "traefik-admin"
    //   # tags = ["loadbalancer", "admin", "traefik.enable=true", "traefik.frontend.rule=Host:admin.10.244.234.64.sslip.io"]
    //   // tags = [
    //   //   "whoami",
    //   //   "loadbalancer",
    //   //   "traefik.backend=whoami",
    //   //   "traefik.frontend.rule=Host:whoami.docker.localhost",
    //   //   "traefik.enable=true"
    //   // ]

    //   port = "admin"

    //   check {
    //     type     = "tcp"
    //     port     = "admin"
    //     interval = "10s"
    //     timeout  = "2s"
    //   }
    // }

    // service {
    //   name = "traefik-frontend"
    //   tags = ["loadbalancer", "frontend"]

    //   port = "frontend"

    //   check {
    //     type     = "tcp"
    //     port     = "frontend"
    //     interval = "10s"
    //     timeout  = "2s"
    //   }
    // }

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

  group "whoamis" {
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
          // args = [
          //   "traefik.backend", "hola",
          //   "traefik.frontend.rule", "Host:whoami.docker.localhost",
          //   "traefik.enable", "true",
          //   "traefik.frontend.entryPoints", "http"
          // ]
      }

      // env {
      //   traefik.backend = "hola"
      // }

      service {
          # name = "whoami"
          // tags = [
          //     "traefik.backend=hola",
          //     "traefik.frontend.rule=Host:whoami.docker.localhost",
          //     "traefik.enable=true",
          //     "traefik.frontend.entryPoints=http"
          // ]
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