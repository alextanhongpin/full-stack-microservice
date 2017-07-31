register srevice



``` bash
# Run 
$ docker-compose up -d
# Scale up to three services
$ docker-compose scale web=3

# Run the consul template to watch for changes. Note that you need consul to be running.
$ ./consul-template -template "nginx.conf.ctmpl:nginx.conf:docker-compose restart nginx" -consul-addr=0.0.0.0:8500 -syslog

# See all existing service
$ docker ps

# Update the ports and service id in the service.json and post to consul. Repeat it for three times
$ curl \
    --request PUT \
    --data @service.json \
    http://localhost:8500/v1/agent/service/register

# Should return results
$ curl http://localhost:8500/v1/agent/services
$ curl http://localhost:8500/v1/catalog/services


{
    "web1": {
        "ID": "web1",
        "Service": "web",
        "Tags": [
            "primary",
            "v1"
        ],
        "Address": "192.168.8.102",
        "Port": 32780,
        "EnableTagOverride": false,
        "CreateIndex": 0,
        "ModifyIndex": 0
    },
    "web2": {
        "ID": "web2",
        "Service": "web",
        "Tags": [
            "primary",
            "v1"
        ],
        "Address": "192.168.8.102",
        "Port": 32781,
        "EnableTagOverride": false,
        "CreateIndex": 0,
        "ModifyIndex": 0
    },
    "web3": {
        "ID": "web3",
        "Service": "web",
        "Tags": [
            "primary",
            "v1"
        ],
        "Address": "192.168.8.102",
        "Port": 32782,
        "EnableTagOverride": false,
        "CreateIndex": 0,
        "ModifyIndex": 0
    }
}

# nginx.conf should be updated automatically
# restart nginx 
$ docker-compose restart nginx

# Make a call to the endpoint, you should get different results each time
$ curl localhost:80
```




In the service that you will register with consul, note that the `Address` field is the ip of the docker container, which is `ipconfig getifaddr en0`
```json
{
  "ID": "web3",
  "Name": "web",
  "Tags": [
    "primary",
    "v1"
  ],
  "Address": "192.168.8.102",
  "Port": 32779,
  "EnableTagOverride": false
}
```

Note that the ip of the services in nginx should be the ip of the container, and not the host. You can get it from `ipconfig getifaddr en0`.
```conf
        upstream node-app {
              least_conn;
              # Not 127.0.0.0
              server 192.168.8.102:32774 weight=10 max_fails=3 fail_timeout=30s;
              server 192.168.8.102:32775 weight=10 max_fails=3 fail_timeout=30s;
              server 192.168.8.102:32776 weight=10 max_fails=3 fail_timeout=30s;
        }
```
Alternative is to use `network_mode: "host"` (--net=host in the older version), but it is less secure: https://docs.docker.com/articles/networking/

```
--net=host -- Tells Docker to skip placing the container inside of a separate network stack. In essence, this choice tells Docker to not containerize the container's networking! While container processes will still be confined to their own filesystem and process list and resource limits, a quick ip addr command will show you that, network-wise, they live “outside” in the main Docker host and have full access to its network interfaces. Note that this does not let the container reconfigure the host network stack — that would require --privileged=true — but it does let container processes open low-numbered ports like any other root process. It also allows the container to access local network services like D-bus. This can lead to processes in the container being able to do unexpected things like restart your computer. You should use this option with caution.```