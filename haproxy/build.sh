./consul-template \
  -template="./haproxy.conf.ctmpl:./out/haproxy.conf" -once