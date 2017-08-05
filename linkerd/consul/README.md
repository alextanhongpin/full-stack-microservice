# Linkerd + Consul

WIP: What is this?

Note that the port is static. For dynamic port, check the docker-compose example

```bash
# Run
$ docker-compose up -d

# View dashboard UI
$ open http://localhost:9990

# Make a request to audit and helloworld
# Note that both ip is static
$ curl localhost:4140/helloworld
$ curl localhost:4140/audit/health

# Make a request to server
# Does not work when ip is dynamic?
$ curl localhost:4140/server


$ http://localhost:4140/audit/health

# See the example with docker compose to call it this way
$ curl -H "Host: audit" http://localhost:4140/audit/health
```