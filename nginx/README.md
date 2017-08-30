## Objective

This example demonstrates how to use Nginx as a reverse-proxy to serve a nodejs express server.

There will be three instances of the nodejs server and it will be load-balanced by Nginx.


## Audience

- Anyone that is interested to know the basic setup of nginx and nodejs
- Anyone that is interested to know how to setup load-balancing for nginx

## References

- The Github repo with the working example can be found [here](https://github.com/alextanhongpin/full-stack-microservice/tree/master/nginx)
- [New Relic on Load Balancing 101](https://www.nginx.com/resources/glossary/load-balancing/)
- [Nginx on What is Load Balancing?](https://www.nginx.com/resources/glossary/load-balancing/)


## Highlights

- Setup docker with nginx
- Create a docker-compose for the setup
- Setup nginx configuration

## TL;DR;

- A short description of the setup, input and output.


## Guide

- Installation

You need to have `docker` installed. You also need to download the image for `nginx` and `web`. When you run `docker-compose up -d`, it will be automatically download the image for you.

- Setup

The `docker-compose.yml` contains the following configuration.
```yaml
version: '3'
services:
  nginx:
    image: nginx:latest
    volumes: 
    - "./nginx.conf:/etc/nginx/nginx.conf"
    ports:
    - 80:80
    depends_on:
    - web
    networks:
      lb:
  web:
    image: alextanhongpin/echo
    ports:
    - 8080
    networks:
      lb:
        aliases:
        - webs
networks:
  lb:
 ```

We are setting up two services in our docker-compose file, which is `nginx` and `web`.

We have an nginx docker image and we mount the volumes so that it will read the default configuration from out root directory.

Note that we are using aliases for the web, which is `webs`. This allows you to call a call to `http://webs`, rather than `web_1`, `web_2` once you scale the services.


The `nginx.conf` is rather simple:

```conf
worker_processes auto;

events { 
        worker_connections 1024; 
}

http {

        upstream node-app {
              least_conn;
              server nginx_web_1:8080 max_fails=3 fail_timeout=30s;
              server nginx_web_2:8080 max_fails=3 fail_timeout=30s;
              server nginx_web_3:8080 max_fails=3 fail_timeout=30s;
        }
         
        server {
              listen 80;
         
              location / {
                proxy_pass http://node-app;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
              }
        }
}
```
The `worker processes` defines the number of worker processes. We set it to `auto` so that it will automatically detect the optimal number of worker proccesses which be based on the number of CPUs.

The default `worker_connections` is set to 1024. To find out the right limit, type the command `ulimit -n` on your terminal.

The `upstream` defines defines a group of servers. Servers can listen on different ports. In addition, servers listening on TCP and UNIX-domain sockets can be mixed.

`least-conn` means we want our service to balance based on the network connection. Else it will default to round-robin.
A new request is sent to the server with the fewest current connections to clients. The relative computing capacity of each server is factored into determining which one has the least connections.

We set the proxy pass to `node-app`. When a request matches a location with a `proxy_pass` directive inside, the request is forwarded to the URL given by the directive.

- Output

To verify that the requests are distributed equally through round-robin, we can check the host id that is returned from the request.
