# Linkerd + Consul

WIP: What is this?


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

# With host
$ curl -H "Host: audit.service.dc1.consul" http://localhost:4140/audit/health

$ curl -H "Host: audit" http://localhost:4140/audit/health
```

Note: It doesn't work with docker swarm not macvlan

docker network create -d macvlan \
    --subnet=192.168.8.0/24 \
    --gateway=192.168.8.100  \
    -o parent=eth0 pub_net

