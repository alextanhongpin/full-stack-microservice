var http = require('http')

var handleRequest = function (request, response) {
  console.log('Received request for URL: ' + request.url)
  response.writeHead(200)
  response.end('Hello World!')
}
var www = http.createServer(handleRequest)
console.log(`listening to port *:8080. press ctrl + c to cancel.`)
www.listen(8080)
