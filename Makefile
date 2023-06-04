SHELL := /bin/bash

APP := $(shell basename $(shell git remote get-url origin))
VERSION := $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY := ghcr.io
NAMESPACE := vhula
TARGETOS := linux
TARGETARCH := amd64
CGO_ENABLED := 0
APP_NAME := uvbot

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build:
	CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o bin/${APP_NAME} -ldflags "-X="github.com/vhula/${APP_NAME}/cmd.appVersion=${VERSION}

linux:
	${MAKE} build TARGETOS=linux TARGETARCH=${TARGETARCH}

windows:
	${MAKE} build TARGETOS=windows TARGETARCH=${TARGETARCH}

macOS:
	${MAKE} build TARGETOS=darwin TARGETARCH=${TARGETARCH}

arm:
	${MAKE} build TARGETOS=${TARGETOS} TARGETARCH=arm

image:
	docker build . -t ${REGISTRY}/${NAMESPACE}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg CGO_ENABLED=${CGO_ENABLED} --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS}

push:
	docker push ${REGISTRY}/${NAMESPACE}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	docker rmi ${REGISTRY}/${NAMESPACE}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
	rm -rf bin
