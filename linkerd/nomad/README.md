
nomad agent -dev
consul agent -dev

nomad plan app.nomad

nomad run -check-index 0 app.nomad

open http://localhost:8500
open http://localhost:9990

curl -H "host: server" localhost:4140

wrk -t10 -c100 -d30s -H "host: server" http://localhost:4140/instable