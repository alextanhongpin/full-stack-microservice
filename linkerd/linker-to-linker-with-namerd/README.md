### Setup

```bash
$ docker-compose up -d

# Go to linkerd dashboard
$ open http://localhost:9990

# Go to namerd dashboard
$ open http://localhost:9991
```
This section shows how the current routing is done. 1/4 of the traffic will be sent to `api2` while 3/4 will be sent to `api1`. `api2` is the newer version.

```yaml
/svc      => /#/io.l5d.linker_to_consul/.local;
# Route one-quarter of the traffic to api and three-quarter to api2
/svc/api1 => /#/io.l5d.linker_to_consul/.local/api2 &3 * /#/io.l5d.linker_to_consul/.local/api1;
```

If you make the call to `api1` four times, you should get 1 call to the `api2` and 3 calls to the `api2`. `api1` returns the text `hello` while `api2` the text `world`.

```bash
# Test call
$ curl -H "Host: api1" localhost:4140


$ for i in {1..20}; do curl -H "Host: api1" localhost:4140; echo ""; done

# Load test, run for 60s
$ wrk -c1 -d120 -t1  -H "Host: api1" http://localhost:4140
```


### Create or update a dtab namespace:

```bash
# During load test immediately change the traffic, check the incoming traffic
# Shift to 50:50, half old api, half new api traffic
$ curl -v -X PUT -d @namerd50.dtab -H "Content-Type: application/dtab" http://localhost:4180/api/1/dtabs/linker_to_consul

# Shift 100% to new api
$ curl -v -X PUT -d @namerd100.dtab -H "Content-Type: application/dtab" http://localhost:4180/api/1/dtabs/linker_to_consul

# Kill new api
$ docker-compose stop api2
```

### Check the updated dtab

```bash
$ curl http://localhost:4180/api/1/dtabs/linker_to_consul
```

In `namerd.dtab`, this will switch the api calls to `api2` directly, with fallback to `api1` if there are issues:
```yaml
/svc=>/#/io.l5d.linker_to_consul/.local;
/svc/api1=>/#/io.l5d.linker_to_consul/.local/api2 | /#/io.l5d.linker_to_consul/.local/api1;
```


docker-compose up -d --no-recreate
