
# Consul + Traefik + Docker Service Discovery

## Technology
- Docker version 17.06.0-ce, build 02c1d87


Setup 
$ docker-compose up -d

Scale the service
$ docker-compose up -d --scale whoami=3

Check the port for traefik
0.0.0.0:32781->80/tcp

ui is available at 
0.0.0.0:32786->8080/tcp

Check the frontend rule for whoami
Host:whoami.consul.localhost

Make a call

curl -H Host:whoami.consul.localhost http://127.0.0.1:32781

It should return a different ip each time:

0.0.1:32781
Hostname: 15578c01006f
IP: 127.0.0.1
IP: 172.19.0.7
GET / HTTP/1.1
Host: whoami.consul.localhost
User-Agent: curl/7.54.0
Accept: */*
Accept-Encoding: gzip
X-Forwarded-For: 172.19.0.1
X-Forwarded-Host: whoami.consul.localhost
X-Forwarded-Proto: http
X-Forwarded-Server: fc261bb9d44e


# Get services

curl http://localhost:8500/v1/agent/services

# Register services

```bash
curl \
    --request PUT \
    --data @service1.json \
    http://localhost:8500/v1/agent/service/register
```

 curl http://consul:8500/v1/catalog/services

 curl -H Host:web.consul.localhost http://127.0.0.1:32781