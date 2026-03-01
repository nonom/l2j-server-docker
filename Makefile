.PHONY: up down logs ps restart custom

## Start the containers in detached mode
up:
	docker compose up -d

## Stop and remove containers
down:
	docker compose down

## Show logs from all containers
logs:
	docker compose logs -f

## Show running containers and their status
ps:
	docker compose ps

## Start containers with custom compose files.
custom:
	docker compose -f docker-compose.yml $$(find custom -mindepth 2 -maxdepth 2 -type f -name compose.yml -exec printf '-f %s ' {} \;) up -d
