const express = require('express')
const app = express()
const os = require('os')
const hostname = os.hostname()

let isSuccess = true
app.get('/', (req, res) => {
  res.status(200).json({
    hostname,
    text: process.env.TEXT || 'hello'
  })
})

app.get('/instable', (req, res) => {
  if (isSuccess) {
    res.status(200).json({
      hostname
    })
  } else {
    res.status(500).json({
      error: 'Internal server error'
    })
  }
})

app.get('/toggle', (req, res) => {
  isSuccess = !isSuccess
  res.status({
    is_success: isSuccess
  })
})

app.get('/health', (req, res) => {
  res.status(200).json({
    message: 'Healthy'
  })
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
