const path = require('path')
const grpc = require('grpc')
const routeguide = grpc.load(path.join(__dirname, 'route.proto')).routeguide

let features = []

function checkFeature (point) {
  console.log(features)
  const existingFeature = features.filter((feature) => {
    return feature.location.latitude === point.latitude && feature.location.longitude === point.longitude
  })

  const hasFeature = existingFeature.length
  if (hasFeature) {
    return existingFeature[0]
  }

  const feature = {
    name: '',
    location: point
  }
  features.push(feature)
  return feature
}

function getFeature (call, callback) {
  const point = call.request
  console.log('getFeature', point)
  callback(null, checkFeature(call.request))
}

function listFeatures (call) {
  const rectangle = call.request
  console.log('listFeatures:rectangle', rectangle)

  const fakeFeature = {
    name: '',
    location: {
      latitude: 409146138,
      longitude: -746188906
    }
  }
  // Fake a for loop to stream data back
  Array(10).fill(fakeFeature).forEach((feature) => {
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
