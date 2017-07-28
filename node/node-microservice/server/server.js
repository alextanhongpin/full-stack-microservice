const express = require('express')
const app = express()
const mongoose = require('mongoose')

mongoose.Promise = global.Promise
console.log('MONGO_URI=', process.env.MONGO_URI)
mongoose.connect(process.env.MONGO_URI, {
  useMongoClient: true
}).then(() => {
  console.log('Successfully connect to mongodb')
}).catch((err) => {
  console.log(err)
})

console.log(process.env)
app.get('/api/v1/users', (req, res) => {
  console.log('successyully called')
  res.status(200).json({
    data: [
      {
        user: 'john',
        age: 1
      }
    ]
  })
})

app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Welcome to node.js app'
  })
})

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
