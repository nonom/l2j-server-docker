.PHONY: up down logs ps recreate build rebuild restart test

compose := docker compose -f docker-compose.yml $(shell find server -type f -name compose.yml | sort | sed 's|^|-f |')
compose_build := docker compose -f docker-compose.yml $(shell find server build -type f -name compose.yml | sort | sed 's|^|-f |')

## Start the containers in detached mode
up:
	@$(compose) up -d

## Stop and remove containers
down:
	@$(compose) down --remove-orphans

## Show logs from all containers
logs:
	@$(compose) logs -f

## Show running containers and their status
ps:
	@$(compose) ps

## Recreate containers.
recreate: down
	@$(compose) up -d --force-recreate

## Build local images.
build:
	@$(compose_build) build

## Rebuild local images and recreate containers.
rebuild:
	@$(compose_build) build --no-cache
	@$(compose) up -d --force-recreate

## Restart all containers
restart: down up

## Run tests against the running stack.
test:
	@$(compose) -f tests/db/compose.yml run --rm test-db
	@$(compose) -f tests/login/compose.yml run --rm test-login
	@$(compose) -f tests/game/compose.yml run --rm test-game
