Start a container

docker run -d --name hello-world-1 -p 80 -e SERVICE_TAGS=urlprefix-/ -e SERVICE_CHECK_HTTP=/ tutum/hello-world
