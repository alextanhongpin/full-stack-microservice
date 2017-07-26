const express = require('express')
const app = express()

app.get('/*', (req, res) => {
  res.status(200).json({
    message: 'Welcome to node.js app'
  })
})

const PORT = process.env.PORT || 8080
const HOST = '0.0.0.0'

app.listen(PORT, HOST)
console.log(`Running on http://${HOST}:${PORT}`)
