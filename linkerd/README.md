# Linkerd + Consul

WIP: What is this?


```bash
# Run
$ docker-compose up -d

# View dashboard UI
$ open localhost:9990

# Make a request to audit and helloworld
# Note that both ip is static
$ curl localhost:4140/helloworld
$ curl localhost:4140/audit/health

# Make a request to web
# Does not work when ip is dynamic?
$ curl localhost:4140/web

# With host
$ curl -H "Host: audit.service.dc1.consul" http://localhost:4140/audit/health

$ curl -H "Host: audit" http://localhost:4140/audit/health
```