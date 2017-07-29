job "lb" {  
  datacenters = ["dc1"]
  type = "service"

//   constraint {
//     attribute = "${node.class}"
//     value     = "loadbalancer"
//   }

  task "traefik" {
    driver = "docker"

    // artifact {
    //   source      = "git::https://github.com/AreteLabs/nomad-examples"
    //   destination = "local/config"
    // }

    // template {
    //   source      = "local/config/traefik/traefik.toml"
    //   destination = "local/traefik/traefik.toml"
    // }

    config {
      image = "traefik:1.3.4"

      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock",
        "${PWD}:/etc/traefik"
      ]

      args = [
        "--web",
        "--docker",
        "--docker.domain=docker.localhost",
        "--logLevel=DEBUG"
      ]

      port_map {
        admin    = 8080
        frontend = 80
      }

      # dns_servers = ["${NOMAD_IP_admin}"]
      dns_servers = ["${attr.unique.network.ip-address}"]
    }

    service {
      name = "traefik-admin"
      # tags = ["loadbalancer", "admin", "traefik.enable=true", "traefik.frontend.rule=Host:admin.10.244.234.64.sslip.io"]
    //   tags = [
    //     "whoami",
    //     "loadbalancer",
    //     "traefik.backend=whoami",
    //     "traefik.frontend.rule=Host:whoami.docker.localhost",
    //     "traefik.enable=true"
    //   ]

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
      // tags = ["loadbalancer", "frontend"]

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
    // constraint {
    //     operator  = "distinct_hosts"
    //     value     = "true"
    // }
    task "service_whoami" {
        driver = "docker"

        config {
            image = "emilevauge/whoami"
        }

        service {
            name = "whoami"
            tags = [
                "traefik.backend=whoami",
                "traefik.frontend.rule=Host:whoami.docker.localhost",
                "traefik.enable=true",
                "traefik.frontend.entryPoints=http"
            ]
            port = "http"
        }
        resources {
            cpu    = 200
            memory = 200

            network {
                mbits = 50

                port "http" {
                }
            }
        }
    }
  }

}