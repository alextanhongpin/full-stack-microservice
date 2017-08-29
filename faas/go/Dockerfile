FROM golang:1.7.3 as builder

WORKDIR /go/src/github.com/alextanhongpin/go-fass

COPY handler.go .

RUN go get -d -v

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .


FROM alpine:latest  
RUN apk --no-cache add ca-certificates
# ADD https://github.com/alexellis/faas/releases/download/0.6.1/fwatchdog /usr/bin  
# RUN chmod +x /usr/bin/fwatchdog
RUN apk --no-cache add curl \ 
    && echo "Pulling watchdog binary from Github." \
    && curl -sSL https://github.com/alexellis/faas/releases/download/0.6.1/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && apk del curl --no-cache

WORKDIR /root/
COPY --from=builder /go/src/github.com/alextanhongpin/go-fass/app .
ENV fprocess="./app"  
CMD ["fwatchdog"]