# Horizontal Scaling with NGINX and nodejs

## Objective

This example demonstrates how to use __NGINX__ (pronounced _engine x_) to horizontally scale your application. For simplicity, we will be using nodejs as our server application, but the concept here applies for any other languages such as __python__ or __go__.

### Audience

- You want to know how to setup a basic NGINX server
- You want to scale your nodejs application horizontally
- You want to do the above with docker-compose

## References

- The working example can be found [here](https://github.com/alextanhongpin/full-stack-microservice/tree/master/nginx)
- The docker image used can be found [here](https://github.com/alextanhongpin/web)
- [New Relic on Load Balancing 101](https://www.nginx.com/resources/glossary/load-balancing/)
- [Nginx on What is Load Balancing?](https://www.nginx.com/resources/glossary/load-balancing/)


## TL;DR;

- You can horizontally scale your nodejs application with NGINX 

Steps:

1. Start the services `docker-compose up -d --scale web=3`
2. Verify the output
```bash
for i in {1..10}                    
do curl localhost:80
echo # This echo is to ensure that every response is printed in a new line
done
```
3. Done!

### Guide


#### Installation

You need to have `docker` and `nodejs` installed in order to run this example. You also need the `nginx` and `web` docker images - this will be automatically downloaded when you run the `docker-compose up -d` command. You can cross-check the version of the tools used below:

```bash
$ docker -v
Docker version 17.06.1-ce, build 874a737)

$ node -v
v8.4.0

$ node -v
5.3.0
```

#### docker-compose config

The `docker-compose.yml` contains the following configuration:

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

We mount nginx volume so that the NGINX docker image will read our `nginx.conf` rather than the default configuration.

Note that we are using aliases for the web, which is `webs`. This allows you to call a call to `http://webs`, rather than `web_1`, `web_2` once you scale the services.

We do not assign a static port to our `web` service - this is important if we want to scale our servers. Every new web services that we spin off will have a unique port assigned to it.

#### NGINX config

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
The `worker processes` defines the number of worker processes. We set it to `auto` so that it will automatically detect the optimal number of worker proccesses which will be based on certain criteria, for example the number of CPUs your machine has.

The default `worker_connections` is set to 1024. To find out the right limit, type the command `ulimit -n` on your terminal.

The `upstream` defines defines a group of servers. Servers can listen on different ports. In this example, we have three servers in __node-app__ group. The names `nginx_web_1`, `nginx_web_2` and `nginx_web_3` are the name of the docker containers, and they are each pointing to the port __8080__.

We set `least-conn` in our upstream directive, which means we want our service to balance based on the network connection. A new request is sent to the server with the fewest current connections to clients. 

We set the proxy pass to `node-app`. When a request matches a location with a `proxy_pass` directive inside, the request is forwarded to the URL given by the directive.

#### Run
This command will spin up the containers and download them if you do not already have one.
We are scaling the web service to three instances, which will be load balanced by NGINX.

```bash
$ docker-compose up -d --scale web=3
```

You should get the following output:

```bash
WARNING: The Docker Engine you're using is running in swarm mode.

Compose does not use swarm mode to deploy services to multiple nodes in a swarm. All containers will be scheduled on the current node.

To deploy your application across the swarm, use `docker stack deploy`.

Creating network "nginx_lb" with the default driver
Creating nginx_web_1 ...
Creating nginx_web_2 ...
Creating nginx_web_3 ...
Creating nginx_web_1 ... done
Creating nginx_web_2 ... done
Creating nginx_web_3 ... done
Creating nginx_nginx_1 ...
Creating nginx_nginx_1 ... done
```

To verify that the containers are already working, just use the `docker ps` command in your terminal:

```bash
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                     NAMES
17126a3c778a        nginx:latest          "nginx -g 'daemon ..."   42 seconds ago      Up 39 seconds       0.0.0.0:80->80/tcp        nginx_nginx_1
137cba26421f        alextanhongpin/echo   "npm start"              44 seconds ago      Up 41 seconds       0.0.0.0:32776->8080/tcp   nginx_web_3
90d9806c03b6        alextanhongpin/echo   "npm start"              44 seconds ago      Up 41 seconds       0.0.0.0:32775->8080/tcp   nginx_web_1
ef131ca514e8        alextanhongpin/echo   "npm start"              44 seconds ago      Up 41 seconds       0.0.0.0:32774->8080/tcp   nginx_web_2
```

Now, if you run a `curl` on any of the web endpoint, you should get a response:

```
$ curl 0.0.0.0:32776                   
{"hostname":"137cba26421f","text":"hello"}%
```

#### Outcome
Each of the web services will have a unique hostname. If we make a call to the nginx server, we can verify that the services has indeed been load-balanced.
```bash
for i in {1..10}                    
do curl localhost:80
echo # This echo is to ensure that every response is printed in a new line
done
{"hostname":"90d9806c03b6","text":"hello"}
{"hostname":"ef131ca514e8","text":"hello"}
{"hostname":"137cba26421f","text":"hello"}
{"hostname":"90d9806c03b6","text":"hello"}
{"hostname":"ef131ca514e8","text":"hello"}
{"hostname":"137cba26421f","text":"hello"}
{"hostname":"90d9806c03b6","text":"hello"}
{"hostname":"ef131ca514e8","text":"hello"}
{"hostname":"137cba26421f","text":"hello"}
{"hostname":"90d9806c03b6","text":"hello"}
```


#### Limitation

In this example, the values are hardcoded in the nginx.conf and you are only limited to scale up to three servers. A guide on how to __automate__ it will be shown in the coming example.