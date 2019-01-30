## Checklist 

Microservice should be language-agnostic - it doesn't matter what language your are coding your greenfield microservice, you should have the following answered before getting started.

Basic:

- [] how to set port/host
- [] how to get hostname
- [] how to get environment variables from `.env`
- [] how to define dynamic config/feature toggles in the app
- [] how to serialize/deserialize json data
- [] how to connect to db/redis/infrastructure etc
- [] how to make http requests/call external services
- [] how to start the application
- [] how to add middlewares
- [] how to add authentication

Intermediate:
- [] how to rate-limit service
- [] how to define proper logging standards
- [] add correlation ids (X-Request-ID)
- [] how to improve observability with opentracing/opencensus
- [] how to add secure headers
- [] how to split code (routers, models, repositories)
- [] how to dockerize the application
