## Setup traefik


What is traefik?


```bash
$ docker-compose up -d

$ cd test
$ docker-compose up -d
$ docker-compose scale whoami=2
$ curl -H Host:whoami.docker.localhost http://127.0.0.1
```