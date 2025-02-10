include ./.env.dist
-include ./.env
export

include ./.makefile/Makefile.color
include ./.makefile/Makefile.function
include ./.makefile/Makefile.killer

.DEFAULT_GOAL := help
OUTPUT := @
MAKEFLAGS += --no-print-directory

DOCKER_COMPOSE := docker compose
ALPINE := $(DOCKER_COMPOSE) exec -e OUTPUT=$(OUTPUT) -it alpine
ALPINE_EXECUTE := $(ALPINE) bash

DOCKER_CONTAINER := $(DOCKER_CONTAINER)
DEV_IMAGE_TAG := $(DEV_IMAGE_TAG)
BASE_IMAGE_TAG := $(BASE_IMAGE_TAG)
PLATFORMS := $(PLATFORMS)

PHP := $(DOCKER_COMPOSE) exec -e OUTPUT=$(OUTPUT) -it php-fpm
PHP_EXECUTE := $(PHP) bash

PHP_NO_TTY := $(DOCKER_COMPOSE) exec -T php-fpm


start:
	$(call measure_time, start-callback)

restart:
	$(call measure_time, restart-callback)

help:
	$(OUTPUT)printf $(COLOR_GREEN)
	$(OUTPUT)bash -c "tail -500 README.makefile.md"
	$(OUTPUT)printf $(COLOR_OFF)"\n\n"

build: \
	docker-login
	DOCKER_BUILDKIT=1 $(DOCKER_COMPOSE) build --pull --compress --parallel --force-rm

stop:
	$(DOCKER_COMPOSE) down --remove-orphans

console:
	$(OUTPUT)$(PHP_EXECUTE)

clean-stack:
	$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans

validate-docker-compose:
	$(OUTPUT)$(DOCKER_COMPOSE) config --quiet && \
	printf $(COLOR_GREEN)"docker-compose.yml OK\n"$(COLOR_OFF) || \
	printf $(COLOR_RED)"docker-compose.yml ERROR\n"$(COLOR_OFF) exit 1

docker-login:
	$(OUTPUT)echo ${DOCKER_PASS} | docker login -u ${DOCKER_REPO_USER} --password-stdin

fix-line-endings:
	$(OUTPUT)find . -type f -print0 | xargs -0 dos2unix

build-%:
	$(call measure_time, build-$*-callback)

start-callback: \
	docker-login \
	build
	$(OUTPUT)$(DOCKER_COMPOSE) up -d --force-recreate
	$(OUTPUT)printf $(COLOR_GREEN)"\n\n"
	$(OUTPUT)bash -c "tail -500 README.makefile.md"
	$(OUTPUT)printf $(COLOR_OFF)
	$(OUTPUT)printf $(COLOR_GREEN)"\n Docker containers built and started! \n\n"$(COLOR_OFF)

restart-callback: \
	clean-stack \
	start-callback

build-%-callback:
	$(call buildx-build, $*)

logo-callback:
	APP_NAME=$(APP_NAME)
	$(OUTPUT)printf $(COLOR_BLUE)
	$(OUTPUT)awk '{printf "%10s%s\n", "", $$0}' .makefile/assets/logo.asci
	$(OUTPUT)printf $(COLOR_WHITE)
	echo  '                                                             '
	echo  "                          $$APP_NAME                         "
	$(OUTPUT)printf $(COLOR_BLUE)
	echo  '                                                             '
	echo  '                Opillion GmbH & Co KG (GPL-3.0 2024)         '
	$(OUTPUT)printf $(COLOR_OFF)"\n\n"
