.PHONY: up down logs ps restart

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

## Restart containers
restart: down up