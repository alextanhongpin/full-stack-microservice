
# Node app.js

Deploy to stack
```bash
$ docker stack deploy web --compose-file docker-compose.yml
```
```bash
# Deploy a new stack or update an existing stack
$ docker stack deploy	

# List stacks
$ docker stack ls

# List the tasks in the stack
$ docker stack ps

# Remove one or more stacks
$ docker stack rm	

# List the services in the stack
$ docker stack services	
```

## To check which port your services are running at

```bash
# Check the services available
$ docker stack services web

# From the service name, inspect the Ports `published port`
$ docker service inspect web_visualizer

# Check the service logs
$ docker service logs web_microservice
```

```bash
$ docker exec -it 9b9790c6ff86 bash
```

Scale microservice
```bash
# docker compose
$ docker-compose scale microservice=3

# docker swarm
$ docker service scale web_client=2
```


Log 
```bash
# docker swarm
$ docker service logs pcpftr84mlhf
```

## Adding more worker to the swarm


```bash
$ docker swarm join-token worker
```

# Getting started with Swarm

## Create a couple of VMs using docker-machine

```bash
$ docker-machine create --driver virtualbox vm1
$ docker-machine create --driver virtualbox vm2
```
We now have two VMs created, named `vm1` and `vm2` respectively.

The first one will act as a manager, and the second a worker.

## Init swarm

```bash
$ docker-machine ssh vm1 "docker swarm init"
```

If you have this error:
```
Error response from daemon: could not choose an IP address to advertise since this system has multiple addresses on different interfaces (10.0.2.15 on eth0 and 192.168.99.100 on eth1) - specify one with --advertise-addr
exit status 1
```

Then run `docker-machine ls`, copy the IP `tcp://192.168.99.100:2376` address and run this command with the ip:
NOTE: Use the port 2377 per instruction...
```bash
$ docker-machine ssh vm1 "docker swarm init --advertise-addr 192.168.99.100:2377"
```

You should get the following response:
```
Swarm initialized: current node (qg3ggqn2zovnj3sf2fkzli4wq) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-4glm9cvz9131hju0w5auf2cbif21fxbwg0hp6dz3x2vskn3r7f-9he9bs7mj16rovprdkvqmuv3j 192.168.99.100:2376

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

```

Now copy the command `docker swarm join --token ....` and run it in `vm2`.


```bash
$ docker-machine ssh vm2 "docker swarm join \
--token SWMTKN-1-1nkce2ckt3y2wwpvc3silx80pskl6dfiajzyo20rtg4dwo1zea-2qucgrey5teosw18d9kzsy76f \
192.168.99.100:2377"
```


You should get the response:
```
This node joined a swarm as a worker.
```

Now SSH into vm1: 
```bash
$ docker-machine ssh vm1
$ docker node ls
# You should see this
NAME   ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
vm1    -        virtualbox   Running   tcp://192.168.99.100:2376           v17.06.0-ce
vm2    -        virtualbox   Running   tcp://192.168.99.101:2376           v17.06.0-ce
```

Now deploy your stack to vm1:

```bash
$ docker-machine scp ./docker-compose.yml vm1:/tmp
$ docker-machine ssh vm1 "docker stack deploy --compose-file /tmp/docker-compose.yml web"

# Find the ssh cert
# $ ls ~/.docker/machine/machines/vm1

# Use sshshuttle to allow outside port to access them
$ ssh docker@192.168.99.100
Password: tcuser

# Requires python
# $ sshuttle -vH -r docker@192.168.99.100 192.168.99.0/24

To call the service 
$ docker swarm join-token manager
Get the port
# and go to
http://192.168.99.100:30003/

```