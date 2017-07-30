# Haproxy with consul template

$ docker-compose up -d

Scale up to three services. Note that in this hardcoded situation haproxy won't start if there are not 3 instances of the service

$ docker-compose up -d --scale web=3
$ docker-compose restart haproxy

See the haproxy monitoring dashboard
open http://localhost:8080


Make a call to see it being round robin
curl -H Host:localhost http://127.0.0.1
