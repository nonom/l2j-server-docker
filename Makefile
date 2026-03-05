.PHONY: up down logs ps recreate restart server test

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

## Run tests against the running stack.
test:
	docker compose -f docker-compose.yml -f tests/db/compose.yml run --rm test-db
	docker compose -f docker-compose.yml -f tests/login/compose.yml run --rm test-login
	docker compose -f docker-compose.yml -f tests/game/compose.yml run --rm test-game

## Start containers with server compose files.
server:
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') up -d
	docker compose logs -f
