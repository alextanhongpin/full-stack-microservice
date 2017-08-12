var initTracer = require('jaeger-client').initTracer

// See schema https://github.com/uber/jaeger-client-node/blob/master/src/configuration.js#L37
var config = {
  'serviceName': 'my-awesome-service',
  sampler: {
    type: 'const',
    param: 1,
    host: 'localhost',
    port: '5775',
    refreshIntervalMs: 500
  }
}
var options = {
  'tags': {
    'my-awesome-service.version': '1.1.2'
  },
  'metrics': null,
  'logger': null
}
var tracer = initTracer(config, options)

const parentSpan = tracer.startSpan('test')
parentSpan.addTags({ level: 0 })

const child = tracer.startSpan('child_span', { childOf: parentSpan })
child.setTag('alpha', '200')
child.setTag('beta', '50')
child.log({state: 'waiting'})

child.log({state: 'done'})
child.finish()
parentSpan.finish()
// con/ sole.log(parentSpan)

// tracer.close()
