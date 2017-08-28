# Function-as-a-service with fass-cli

```bash
# Build the docker image
$ docker build -t alextanhongpin/go-fass-v2 .

# Run it
$ docker-compose up -d

# Make a call
$ curl -X POST -v -d '{"event": "commit", "repository": "faas", "user": "alexellis"}' localhost:8080/alextanhongpin/go-fass-v2

```

The go images are build with multi-stage builds, thus reducing the image size considerably.

![./assets/multi-stage.png](Multi stage image)