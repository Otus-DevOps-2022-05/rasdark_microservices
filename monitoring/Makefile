USER_NAME ?= rasdark
CUR := $(CURDIR)
.DEFAULT_GOAL := all

.PHONY: build
build: prometheus mongo blackbox app

.PHONY: app
app:
	@echo 'START BUILD APP TARGET'
	@for i in ui post-py comment; do \
	cd $(CUR)/../src/$$i; \
	bash docker_build.sh; \
	done

.PHONY: prometheus
prometheus:
	@echo 'START BUILD PROMETHEUS TARGET'
	@cd ${CUR}/prometheus; docker build -t $(USER_NAME)/prometheus .

.PHONY: mongo
mongo:
	@echo 'START BUILD MONGO TARGET'
	@cd ${CUR}/mongodb-exporter; docker build -t $(USER_NAME)/mongodb-exporter .

.PHONY: blackbox
blackbox:
	@echo 'START BUILD BLACKBOX TARGET'
	@cd ${CUR}/blackbox-exporter; docker build -t $(USER_NAME)/blackbox-exporter .

.PHONY: start
start:
	@echo 'START DOCKER COMPOSE'
	@cd ${CUR}/../docker; docker compose -f ./docker-compose.yml up -d

.PHONY: stop
stop:
	@echo 'STOP DOCKER COMPOSE'
	@cd ${CUR}/../docker; docker compose down

.PHONY: push
push:
	@echo 'PUSH ALL IMAGES'
	docker login
	docker push $(USER_NAME)/ui
	docker push $(USER_NAME)/comment
	docker push $(USER_NAME)/post
	docker push $(USER_NAME)/prometheus
	docker push $(USER_NAME)/mongodb-exporter
	docker push $(USER_NAME)/blackbox-exporter

.PHONY: all
all: build push start
