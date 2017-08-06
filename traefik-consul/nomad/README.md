##  Method 1
Run traefik, consul and nomad separately

``` bash
# Requires permission to access port 80
$ sudo ./traefik_darwin-amd64 -configFile=traefik.toml

$ nomad -v
# Nomad v0.6.0
$ nomad agent -dev

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

Run nomad job directly.

```bash
$ nomad plan app.nomad
$ nomad run -check-index 0 app.nomad
```

Go to traefik interface

```bash
$ open http://localhost:8080
```