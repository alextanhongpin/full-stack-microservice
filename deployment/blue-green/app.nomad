# Example of running blue/green deployments in nomad
job "api" {
  datacenters = ["dc1"]
  type = "service"

  group "cache" {
    count = 5

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    ephemeral_disk {
      size = 300
    }

    update {
        max_parallel = 1
        canary = 5 # remove this, and it will become rolling upgrades
        min_healthy_time = "30s"
        healthy_deadline = "10m"
        auto_revert = true
    }

    task "apiv1" {
      driver = "docker"

      config {
        image = "alextanhongpin/web"
        port_map {
          db = 8080
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
        network {
          mbits = 10
          port "db" {}
        }
      }
    }
  }
}