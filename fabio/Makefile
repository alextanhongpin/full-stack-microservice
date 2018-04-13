up:
	@docker-compose up -d

down:
	@docker-compose down

svc1:
	@curl -H "Host: svc1" http://127.0.0.1:9999

svc2:
	@curl -H "Host: web" http://127.0.0.1:9999

scale:
	@docker-compose up -d --scale svc1=3