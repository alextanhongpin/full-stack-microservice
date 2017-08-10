GOOS=linux go build -o app .

CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .


docker build -t alextanhongpin/web-go .
docker run -d -p 8080 alextanhongpin/web-go

building directly from docker-compose will not work

Remember to clear tmp to remove .kibana index

Login to kibana with elastic and changeme, not kibana and changeme