# Node Microservice

## Start Docker

Start 3 instances of node microservices with the following commands:

```bash
$ docker-compose up -d --scale microservice=3
```

## Create an image and push it to docker (requires an account)
```
$ docker build -t myusername/web .
$ docker push myusername/web

$ cat docker-compose.yml
web:
  image: myusername/web

$ docker-compose up -d
$ docker-compose scale web=3
```