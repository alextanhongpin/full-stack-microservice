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
$ curl -H "l5d-name: audit" localhost:4140/health # I am healthy!%
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