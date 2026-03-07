.PHONY: up down logs ps build recreate rebuild restart test

## Start the containers in detached mode
up:
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') up -d
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') logs -f

## Stop and remove containers
down:
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') down --remove-orphans

## Show logs from all containers
logs:
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') logs -f

## Show running containers and their status
ps:
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') ps

## Build local images.
build:
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') build

## Recreate containers.
recreate:
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') down
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') up -d --force-recreate
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') logs -f

## Rebuild local images and recreate containers.
rebuild:
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') build
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') up -d --force-recreate
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') logs -f

## Restart all containers
restart: down up
	docker compose -f docker-compose.yml $$(find server -type f -name compose.yml | sort | sed 's|^|-f |') logs -f

## Run tests against the running stack.
test:
	for f in $$(find tests -type f -name compose.yml | sort); do \
		docker compose -f docker-compose.yml -f $$f run --rm test || exit 1; \
	done
