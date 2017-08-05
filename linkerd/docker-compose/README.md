# Linkerd + Consul

WIP: What is this?


```bash
# Run
$ docker-compose up -d

# View dashboard UI
$ open http://localhost:9990


# To call linkerd with pathname, check the consul example
$ curl localhost:4140/helloworld
$ curl localhost:4140/audit/health

# With host
$ curl -H "l5d-name: audit" localhost:4140/ # returns Hello World!%

# If your service has another path name (/audit/health), this is how you specify it
$ curl -H "host: audit" localhost:4140/health # I am healthy!%

$ curl -H "host: server" localhost:4140

```


```yaml
consul-registrator:
    image: gliderlabs/registrator:v7
    # This ip command is necessary for other containers port to be dynamic
    # for mac, you can use this to get your ip addr, or optionally `$ ipconfig getifaddr en0`
    command: -ip=docker.for.mac.localhost consul://consul:8500
    # ...

server:
    image: alextanhongpin/echo
    ports:
    # Dynamic port:
    - 8080
    # Instead of static port:
    # - 8080:8080
```

We include dc in the naming structure so that we can support multi-dc service routing. For example, in the following dtab, we send 90% of traffic to dc1 and 10% of traffic to dc2:
```yaml
/srv => 9 * /io.l5d.consul/dc1 & 1 * /io.l5d.consul/dc2;
/host => /srv;
/method => /$/io.buoyant.http.anyMethodPfx/host;
/http/1.1 =>  /method;
```


Load test
```bash
$ wrk -c100 -t1 -d10s -H "host: server" http://localhost:4140
```