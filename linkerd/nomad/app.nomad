
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

  group "mesh" {
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

    task "linkerd" {
      driver = "raw_exec"

      config {
        # Note that the docker image does not work when trying to connect to local consul
        # image = "buoyantio/linkerd:1.1.2"
        command = "/Users/alextanhongpin/Documents/nodejs/full-stack-microservice/linkerd/nomad/linkerd/linkerd-1.1.2-exec"
        args = [
          "/Users/alextanhongpin/Documents/nodejs/full-stack-microservice/linkerd/nomad/linkerd.conf.yaml"
        ]
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
        network {
          mbits = 10
          port "ui" {
            static = "9990"
          }

          port "in" {
            static = "4140"
          }

          port "out" {
            static = "4141"
          }
        }
      }

      // service {
      //   name = "global-redis-check"
      //   tags = ["global", "cache"]
      //   port = "db"
      //   check {
      //     name     = "alive"
      //     type     = "tcp"
      //     interval = "10s"
      //     timeout  = "2s"
      //   }
      // }
    }
  }

  group "web" {
    count = 3

    task "server" {
      driver = "docker"

      config {
        image = "alextanhongpin/echo:0.0.2"
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
        name = "server"
        tags = ["web", "server"]
        port = "http"
        check {
          type     = "http"
          port     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}