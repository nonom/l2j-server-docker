.PHONY: up down logs ps recreate build rebuild restart test

compose := docker compose -f docker-compose.yml $(shell find server -type f -name compose.yml | sort | sed 's|^|-f |')

## Start the containers in detached mode
up:
	@$(compose) up -d
	@$(compose) logs -f

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
	@$(compose) logs -f

## Build local images.
build:
	$(compose) build

## Rebuild local images and recreate containers.
rebuild:
	@$(compose) build
	@$(compose) up -d --force-recreate
	@$(compose) logs -f

## Restart all containers
restart: down up
	@$(compose) logs -f

## Run tests against the running stack.
test:
	for f in $$(find tests -type f -name compose.yml | sort); do \
		@docker compose -f docker-compose.yml -f $$f run --rm test || exit 1; \
	done
