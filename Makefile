CONTAINER_ROOT := /app

SHORT_NAME ?= gutenberg
VERSION ?= 0.4.1
IMAGE_PREFIX ?= jhansen
DEV_REGISTRY ?= quay.io
DEIS_REGISTRY ?= ${DEV_REGISTRY}/
IMAGE := ${DEIS_REGISTRY}${IMAGE_PREFIX}/${SHORT_NAME}:${VERSION}

DOCKER_RUN_CMD := docker run -v $(CURDIR):$(CONTAINER_ROOT) --env-file=$(CONTAINER_ENV) --rm $(IMAGE)
DOCKER_SHELL_CMD := docker run -v $(CURDIR):$(CONTAINER_ROOT) --env-file=$(CONTAINER_ENV) --rm -it $(IMAGE)

prep:
	$(DOCKER_RUN_CMD) $(CONTAINER_ROOT)/script/prep

test: prep
	$(DOCKER_RUN_CMD) $(CONTAINER_ROOT)/script/build

build:
	$(DOCKER_RUN_CMD) $(CONTAINER_ROOT)/script/build

deploy:
	$(DOCKER_RUN_CMD) $(CONTAINER_ROOT)/script/deploy

shell:
	$(DOCKER_SHELL_CMD) /bin/bash
