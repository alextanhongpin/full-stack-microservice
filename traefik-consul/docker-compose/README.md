
# Get services


curl http://localhost:8500/v1/agent/services

# Register services

curl \
    --request PUT \
    --data @service1.json \
    http://localhost:8500/v1/agent/service/register