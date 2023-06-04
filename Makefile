SHELL := /bin/bash

VERSION := $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS := linux
TARGETARCH := arm64
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
	docker build . -t ${REGISTRY}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg CGO_ENABLED=${CGO_ENABLED} --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS}

push:
	docker push ${REGISTRY}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	docker rmi ${REGISTRY}:${VERSION}-${TARGETOS}-${TARGETARCH}
	rm -rf bin
