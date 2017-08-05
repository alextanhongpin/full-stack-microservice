
# macvlan

This example doesn't work if you use the gateway or ip as suggested. Use this:
```
    --subnet=172.16.86.0/24 \
    --gateway=172.16.86.1

    and 
    172.16.86.2/24
```
```bash
# Create a new docker machine with the name dock0
$ docker-machine create dock0

# SSH into the newly created machine
$ docker-machine ssh dock0

# for macvlan bridge mode, get some details about existing network
$ ip route
# -> default via 10.0.2.2 dev eth0  metric 1
# 10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15

$ netstat -r
# 10.0.2.2 is the gateway
# 10.0.2.0/24 is the subnet

$ ip a show eth0

# Create a new macvlan network
# The gateway and subnet is up to you
# Note that the parent is local internet, on mac it's supposed to be en0, but it doesn't work
$ docker network  create  -d macvlan \
    --subnet=172.16.86.0/24 \
    --gateway=172.16.86.1  \
	-o macvlan_mode=bridge \
    -o parent=eth0 macv0

# Error thrown from mac if you use en0
# Error response from daemon: invalid subinterface vlan name en0, example formatting is eth0.10
$ docker network inspect macv0
[
    {
        "Name": "macv0",
        "Id": "0e6cb124422c2693d1ae64a37f921f8aa67a4e3a8e42af56f5e661a7d739ed31",
        "Created": "2017-08-05T06:40:56.915091136Z",
        "Scope": "local",
        "Driver": "macvlan",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "192.168.8.0/24",
                    "Gateway": "192.168.8.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {
            "macvlan_mode": "bridge",
            "parent": "eth0"
        },
        "Labels": {}
    }
]

# Create a container that listens to the network
$ docker run --net=macv0 --rm -p 80:80 -d  emilevauge/whoami

# check 
$ docker ps



# inspect the ipaddr IPv4Address
$ docker network inspect macv0
# or
$ docker inspect container_name | grep IPAddress

# Curl to the docker container that is running
$ curl 10.0.0.2 
# curl: (7) Failed to connect to 10.0.2.2 port 80: Connection refused

# Create a macvlan network on the host
$ sudo ip link add lmacv0 link eth0 type macvlan mode bridge
#  Link them (should not be same as subnet value in docker, the ip should be an un-assigned address on the same network)
# If your subnet is 172.16.86.0/24, take 
# 172.16.86.1/24
$ sudo ip addr add 172.16.86.1/24  dev lmacv0

# Restart
$ sudo ifconfig lmacv0 up


# The host can now call the docker container
$ curl <IP_ADDR>
```
