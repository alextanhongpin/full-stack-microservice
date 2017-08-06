# full-stack-microservice

The goal is to design a working microservice architecture with the following components:

## Infrastructure

- Terraform

## Load Balancer

- Nginx
- HAProxy
- Traefik
- Envoy
- Linkerd
- Fabio

## Scheduler

- Nomad

## Orchestration

- Docker Swarm
- Kubernetes

## API Gateway

- Kong
- Tyk
- Istio
- Linkerd (since it does load balancing, circuit breaker)
- express-gateway
- API Umbrella

## Search

- Elasticsearch
- Solr

## Cache

- Redis (also for rate-limiting)
- Memcached
- Varnish
- Zipnish

## Tracing

- OpenTracing
- OpenZipkin

## Auth

- OpenId Connect
- OAuth2

## Secrets

- DockerSecrets
- Vault

## Transport

- Kafka
- Nats
- grpc
- protobuff
- Thrift
- Avro
- RabbitMQ
- ZeroMQ

## Documentation

- Swagger

### Others

- Client/server-side service discovery (nodejs resilient, etcd, Linkerd, Consul)
- Consul/etcd setup
- Circuit breaker
- Docker-compose or nomad setup
- Dynamic ports and service registry
- 12-Factor app practices
- Heteregenous clients (nodejs, go, python)
- Transport protocol (kafka, nats, rabbitmq, rpc, grpc, protobuff)
- Caching (Redis/memcached)
- API Gateway (kong, API Umbrella, AWS API Gateway)
- OpenID connect
- Sharding/Clustering of storage
- Vault

