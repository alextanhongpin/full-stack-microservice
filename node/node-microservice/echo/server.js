const express = require('express')
const app = express()
const os = require('os')

app.get('/', (req, res) => {
  // Without http, it will throw error "Invalid protocol: microservice:"
  res.status(200).json(Object.assign({}, req.headers, { hostname: os.hostname() || req.hostname }, os.networkInterfaces()))
})

// Round robin when using aliases

const PORT = process.env.PORT || 8080
const HOST = '0.0.0.0'

const server = app.listen(PORT, HOST)
console.log(`Running on http://${HOST}:${PORT}`)

// this function is called when you want the server to die gracefully
// i.e. wait for existing connections
const gracefulShutdown = () => {
  console.log('Received kill signal, shutting down gracefully.')
  server.close(() => {
    console.log('Closed out remaining connections.')
    process.exit()
  })

  setTimeout(function () {
    console.error('Could not close connections in time, forcefully shutting down')
    process.exit()
  }, 10 * 1000)
}

// listen for TERM signal .e.g. kill
process.on('SIGTERM', gracefulShutdown)

// listen for INT signal e.g. Ctrl-C
process.on('SIGINT', gracefulShutdown)
