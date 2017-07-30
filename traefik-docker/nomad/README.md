Run nomad agent with a specified `-data-dir`, else the following error will be thrown:

```
07/30/17 14:49:53 +08  Driver Failure  failed to start task "whoami" for alloc "077ad35c-a2a1-2bc7-26d6-871b07d54590": Failed to create container: API error (500): {"message":"create data/nomad/alloc/077ad35c-a2a1-2bc7-26d6-871b07d54590/alloc: \"data/nomad/alloc/077ad35c-a2a1-2bc7-26d6-871b07d54590/alloc\" includes invalid characters for a local volume name, only \"[a-zA-Z0-9][a-zA-Z0-9_.-]\" are allowed. If you intended to pass a host directory, use absolute path"}
```

```bash
# Note the equal sign after the -data-dir flag, and the path must be absolute
$ nomad agent -dev -data-dir=${PWD}/tmp/nomad
$ consul agent -dev
```

Create a network and set the labels for the containers
$ docker network create "something"

traefik.docker.network = "something"


curl -H Host:traefik-36c19ecf-842d-7c40-f88a-a276d93b4d7f.docker.localhost http://127.0.0.1


curl -H Host:docker.localhost http://127.0.0.1