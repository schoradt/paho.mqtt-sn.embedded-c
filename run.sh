#!/bin/bash

docker run --detach --tty --rm -p 1883:1883/udp --name=paho-mqtt-sn-gateway gst/paho-mqtt-sn-gateway