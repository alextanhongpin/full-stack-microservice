const path = require('path')
const grpc = require('grpc')

const routeguide = grpc.load(path.join(__dirname, 'route.proto')).routeguide

const client = new routeguide.RouteGuide('localhost:50051', grpc.credentials.createInsecure())

// Simple RPC, client sends a request to the server and wait for a response
function runGetFeature () {
  const point = {
    latitude: 409146138,
    longitude: -746188906
  }

  client.getFeature(point, (error, feature) => {
    if (error) {
      console.log('error getting feature', error)
    }
    console.log('got feature', feature)
  })
}
// Server-side streaming RPC. Client sends a requests to the server and gets
// a stream to read a sequence of messages back
function runListFeatures () {
  const rectangle = {
    lo: {
      latitude: 400000000,
      longitude: -750000000
    },
    hi: {
      latitude: 420000000,
      longitude: -730000000
    }
  }
  const call = client.listFeatures(rectangle)
  call.on('data', (feature) => {
    console.log('got list feature', feature)
  })

  call.on('end', (error, done) => {
    if (error) {
      console.log('error list features', error)
    }
    console.log('got list features', done)
  })
}

// Client-side streaming RPC where client writes a sequence of messages
// and sends them to the server. Once the client has finished writing the messages,
// it waits for the server to read them all and return it's response
function runRecordRoute () {
  function makeRandomPoint () {
    return {
      latitude: Math.floor(Math.random() * 100000),
      longitude: Math.floor(Math.random() * 100000)
    }
  }
  const call = client.recordRoute((error, stats) => {
    if (error) {
      console.log('get record route error', error)
    }
    console.log('getRecordRoute', stats)
  })
  Array(10).fill(makeRandomPoint()).forEach((point) => {
    call.write(point)
  })
  call.end()
}

// bidirectional streaming RPC where both sides send a sequence of messages
// using read-write stream

function runRouteChat () {
  const call = client.routeChat()
  call.on('data', (note) => {
    console.log('routeChat:note', note)
  })
  call.on('end', (error, done) => {
    if (error) {
      console.log(error)
    }
    console.log(done)
  })

  const note = {
    location: {
      latitude: 0,
      longitude: 0
    },
    message: 'First message'
  }
  Array(10).fill(note).forEach((note) => {
    call.write(note)
  })
  call.end()
}

runRouteChat()
