# Linker with Namerd

A basic setup of linker-to-linker approach with `linkerd`, using `namerd` for dynamic configuration of dtabs. 


### Setup

```bash
# Start docker
$ docker-compose up -d

# Go to linkerd ui
$ open http://localhost:9990

# Go to namerd dashboard
$ open http://localhost:9991
```

This code shows how to distribute traffic in linkerd, particularly useful for `blue/green` deployment. One-tenth of the traffic will be sent to `api2` and the rest to `api1`. `api2` is the newer version that needs to be released.

```yaml
/svc      => /#/io.l5d.linker_to_consul/.local;
/svc/api1 => 1 * /#/io.l5d.linker_to_consul/.local/api2 & 9 * /#/io.l5d.linker_to_consul/.local/api1;
```

If you make the call to `api1` ten times, you should get one call to the `api2` and nine calls to the `api2`. `api1` returns the text `hello` while `api2` the text `world`.

```bash
# Making a single call
$ curl -H "Host: api1" localhost:4140

# Making twenty calls
$ for i in {1..20}; do curl -H "Host: api1" localhost:4140; echo ""; done
```

Let's simulate a running traffic, and make dynamic configuration to change the routing.

```
# To simulate running traffic, runs for 120s
$ wrk -c1 -d120 -t1  -H "Host: api1" http://localhost:4140
```

While the traffic is running, make a request to split the traffic by half.

```bash
# Shift to 50:50, half old api, half new api traffic
$ curl -v -X PUT -d @namerd50.dtab -H "Content-Type: application/dtab" http://localhost:4180/api/1/dtabs/linker_to_consul

# Shift 100% to new api
$ curl -v -X PUT -d @namerd100.dtab -H "Content-Type: application/dtab" http://localhost:4180/api/1/dtabs/linker_to_consul
```

If the new api is down, `linkerd/namerd` will hold a cache of the previous running service and will automatically revert back.

```bash
# Kill new api
$ docker-compose stop api2
```

### Miscellaneous

#### Check the updated dtab

```bash
$ curl http://localhost:4180/api/1/dtabs/linker_to_consul
```

#### Service Fallback

In `namerd.dtab`, this will switch the api calls to `api2` directly, with fallback to `api1` if there are issues:
```yaml
/svc=>/#/io.l5d.linker_to_consul/.local;
/svc/api1=>/#/io.l5d.linker_to_consul/.local/api2 | /#/io.l5d.linker_to_consul/.local/api1;
```
