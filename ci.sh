#!/bin/bash

set -e

mkdir -p build

DOCKER_BUILDKIT=1 docker build -t gst/paho-mqtt-sn-gateway:latest .

docker image save -o build/paho-mqtt-sn-gateway.tar gst/paho-mqtt-sn-gateway:latest
