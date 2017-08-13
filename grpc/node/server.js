const path = require('path')
const grpc = require('grpc')
const routeguide = grpc.load(path.join(__dirname, 'route.proto')).routeguide

function checkFeature (point) {
  const feature = {
    name: '',
    location: point
  }
  return feature
}

function getFeature (call, callback) {
  const point = call.request
  console.log('getFeature', point)
  if (Math.random() < 0.5) {
      // Fake error
    return callback(new Error('Error getting point'))
  }
  callback(null, checkFeature(call.request))
}

function listFeatures (call) {
  const rectangle = call.request
  console.log('listFeatures:rectangle', rectangle)

  // Fake a for loop to stream data back
  Array(10).fill(0).map((_, i) => {
    const feature = {
      name: i.toString(),
      location: {
        latitude: 409146138,
        longitude: -746188906
      }
    }
    return feature
  }).forEach((feature) => {
    if (Math.random() < 0.5) {
      console.log('hitting error')
      // throw new Error('shit')
      call.write(new Error('shit'))
    }
    call.write(feature)
  })

  call.end()
}

function recordRoute (call, callback) {
  let pointCount = 0
  let featureCount = 0
  const startTime = process.hrtime()
  call.on('data', (point) => {
    console.log('recordRoute:point', point)
    pointCount += 1
    featureCount += 1
  })

  call.on('end', () => {
    if (Math.random() < 0.5) {
      return callback(new Error('intended error'))
    }
    callback(null, {
      point_count: pointCount,
      feature_count: featureCount,
      distance: 100,
      elapsed_time: process.hrtime(startTime)[0]
    })
  })
}

function routeChat (call) {
  call.on('data', (note) => {
    console.log('routeChat', note)
    if (Math.random() < 0.5) {
      call.write(new Error('intended error'))
    }
    call.write(note)
  })

  call.on('end', () => {
    call.end()
  })
}

function getServer () {
  const server = new grpc.Server()
  server.addService(routeguide.RouteGuide.service, {
    getFeature,
    listFeatures,
    recordRoute,
    routeChat
  })
  return server
}

if (require.main === module) {
  const routeServer = getServer()

  routeServer.bind('0.0.0.0:50051', grpc.ServerCredentials.createInsecure())

  routeServer.start()
  console.log(`started server at port *:50051`)
}
