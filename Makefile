# ---------------------------------------------------------------------------- #
#                              Inception Makefile                              #
# ---------------------------------------------------------------------------- #
COMPOSE_FILE := srcs/docker-compose.yml
ENV_FILE := srcs/.env

# ---------------------------------------------------------------------------- #
# Default target
# ---------------------------------------------------------------------------- #
all: up

# ---------------------------------------------------------------------------- #
# Docker Compose Lifecycle
# ---------------------------------------------------------------------------- #
up: setup
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

down:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down

start:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) start

stop:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) stop

status:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) ps

logs:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) logs


# ---------------------------------------------------------------------------- #
# Setup Directories and Hosts
# ---------------------------------------------------------------------------- #
setup:
	$(ENV) ./tools/setup-log.sh
	$(ENV) ./tools/setup-host.sh
	sudo mkdir -p "/home/$(LOGIN)"
	sudo mkdir -p "$(VOLUME_PATH)/mariadb-data"
	sudo mkdir -p "$(VOLUME_PATH)/wordpress-data"

# ---------------------------------------------------------------------------- #
# Start/Stop Individual Services
# ---------------------------------------------------------------------------- #
start-nginx:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) start nginx

stop-nginx:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) stop nginx

start-wordpress:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) start wordpress

stop-wordpress:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) stop wordpress

start-mariadb:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) start mariadb

stop-mariadb:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) stop mariadb

# ---------------------------------------------------------------------------- #
# MariaDB Testing Target
# ---------------------------------------------------------------------------- #
test-mariadb:
	@echo "[Testing] Running SQL user and DB creation test in MariaDB..."
	docker exec -i mariadb mariadb -u root -p"$(DB_ROOT_PASS)" < tools/mariadb-test.sql
	@echo "[Done] Test DB and user created. Check logs for SQL output."

logs-mariadb:
	docker logs mariadb

# ---------------------------------------------------------------------------- #
# Clean up volumes and data
# ---------------------------------------------------------------------------- #
clean:
	rm -rf "$(VOLUME_PATH)"

fclean: clean
	$(ENV) ./tools/nonspec-log.sh
	docker system prune -af --volumes
#	docker volume rm srcs_mariadb-data srcs_wordpress-data

.PHONY: all up down start stop status logs setup clean fclean

