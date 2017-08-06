# nomad traefik

If you have trouble running nomad, set the data dir when executing `nomad agent -dev -data-dir=${PWD}/tmp/nomad`.

Don't forget to execute `chmod + x` on the traefik binary downloaded to make it an executable.

##  Method 1
Run traefik, consul and nomad separately

``` bash
# Requires permission to access port 80
$ sudo ./traefik_darwin-amd64 -configFile=traefik.toml

$ nomad -v
# Nomad v0.6.0

# You might need to run sudo to allow the traefik binary to access port 80
$ sudo nomad agent -dev

$ consul -v
# Consul v0.9.0
$ consul agent -dev
```

Run nomad job

```bash
$ nomad plan app.nomad
$ nomad run -check-index 0 app.nomad
```

Go to traefik interface

```bash
$ open http://localhost:8080
```

Make a call to the traefik endpoint

```bash
$ curl - H "Host:web.consul.localhost" http://localhost
```

## Method 2

TODO: Use artifacts to pull traefik binary.

Run nomad job directly. sudo is required when starting nomad and consul to allow the traefik binary to access port 80.

```bash
$ nomad plan app.nomad
$ nomad run -check-index 0 app.nomad
```

Go to traefik interface

```bash
$ open http://localhost:8080
```

Test the circuit breaker capability:
```bash
$ wrk -t10 -c100 -d15s -H "Host: web.consul.localhost" http://localhost/instable
$ curl -H "Host: web.consul.localhost" http://localhost
# Test the failing endpoint
$ curl -H "Host: web.consul.localhost" http://localhost/instable

# Alternatively run the go file if you do not have wrk installed
$ go run main.go
```