FROM golang:1.7.3
RUN mkdir -p /go/src/app  
COPY handler.go /go/src/app  
WORKDIR /go/src/app  
RUN go get -d -v  
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

ADD https://github.com/alexellis/faas/releases/download/0.6.1/fwatchdog /usr/bin  
RUN chmod +x /usr/bin/fwatchdog

ENV fprocess="/go/src/app/app"  
CMD ["fwatchdog"]