.PHONY: up down logs ps recreate restart custom

## Start the containers in detached mode
up:
	docker compose up -d
	docker compose logs -f

## Stop and remove containers
down:
	docker compose down --remove-orphans

## Show logs from all containers
logs:
	docker compose logs -f

## Show running containers and their status
ps:
	docker compose ps

## Recreate containers.
recreate:
	docker compose down
	docker compose up -d --force-recreate

## Restart all containers
restart: down up
	docker compose logs -f

## Start containers with custom compose files.
custom:
	docker compose -f docker-compose.yml $$(find custom -type f -name compose.yml | sort | sed 's|^|-f |') up -d
	docker compose logs -f
