.PHONY: build k3d sync-secrets dev lint format format-imports test

PACKAGE_DIR=helloworld
IMAGE_NAME=smana/helloworld
IMAGE_TAG=$(shell git rev-parse --short HEAD)-dirty

k3d:
	./run-k3d.sh

sync-secrets: k3d
	./sync-secrets.sh

build: k3d
	skaffold build -p local --skip-tests

dev: k3d sync-secrets
	skaffold dev --port-forward -p local

format: build
	docker run --rm -v $(shell pwd)/${PACKAGE_DIR}:/app/${PACKAGE_DIR} ${IMAGE_NAME}:${IMAGE_TAG} black -l 79 --py36 ${PACKAGE_DIR}

format-imports: build
	docker run --rm -v $(shell pwd)/${PACKAGE_DIR}:/app/${PACKAGE_DIR} -v $(shell pwd)/tests:/app/tests ${IMAGE_NAME}:${IMAGE_TAG} isort -y -rc ${PACKAGE_DIR}/. tests/.

complexity: build
	docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} xenon --max-absolute B --max-modules B --max-average A ${PACKAGE_DIR}/

lint: build
	docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} pylint --reports=n ${PACKAGE_DIR}

test: build
	docker run --rm -v $(shell pwd)/reports:/app/reports ${IMAGE_NAME}:${IMAGE_TAG} pytest tests
