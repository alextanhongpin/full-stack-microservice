# opentracing-node

This is an example of `opentracing` with Uber's `jaeger` library.

### Setup

To run jaeger:

```bash
$ docker run -d -p5775:5775/udp -p6831:6831/udp -p6832:6832/udp \
  -p5778:5778 -p16686:16686 -p14268:14268 jaegertracing/all-in-one:latest
```


To run the server:

```bash
$ node server.js
```
