
job "app" {
  datacenters = ["dc1"]
  type = "service"


  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
  }

  group "app" {
    count = 3
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    ephemeral_disk {
      size = 300
    }

    task "web" {
      driver = "docker"

      config {
        image = "alextanhongpin/echo:0.0.1"
        port_map {
          http = 8080
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "echo"
        tags = [
            "traefik.tags=traefik", # Services without this tag will be excluded (including nomad and consul)
            "traefik.backend=web",
            "traefik.frontend.rule=Host:web.consul.localhost",
            "traefik.enable=true",
            "traefik.frontend.entryPoints=http",
            "traefik.backend.circuitbreaker=ResponseCodeRatio(400, 600, 0, 600) > 0.2", 
            # NetworkErrorRatio() > 0.5: watch error ratio over 10 second sliding window for a frontend
            # LatencyAtQuantileMS(50.0) > 50: watch latency at quantile in milliseconds.
            # ResponseCodeRatio(500, 600, 0, 600) > 0.5: ratio of response codes in range [500-600) to [0-600)
            "traefik.backend.loadbalancer=drr",
            "traefik.backend.maxconn.amount=100",
            # "traefik.backend.maxconn.extractorfunc=client.ip"
            "traefik.backend.maxconn.extractorfunc=request.host"
        ]
        port = "http"
        check {
          type     = "http"
          port     = "http"
          path     = "/health"
          interval = "5s"
          timeout  = "2s"
        }
      }
    }
  }

  group "traefik" {
    count = 1
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    ephemeral_disk {
      size = 300
    }
    task "traefik" {
      # The traefik docker image does not work with consul
      driver = "raw_exec"

      config {
        command = "/Users/alextanhongpin/Documents/nodejs/full-stack-microservice/traefik-consul/nomad/traefik_darwin-amd64"
        args = [
          "--configfile=/Users/alextanhongpin/Documents/nodejs/full-stack-microservice/traefik-consul/nomad/traefik.toml"
        ]
      }

      resources {
        cpu    = 200
        memory = 200

        network {
          mbits = 50

          port "admin" {
            static = "8080"
          }

          port "frontend" {
            static = "80"
          }
        }
      }
    }
  }
}