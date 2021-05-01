#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: build.sh { udp | udp6 | xbee | loralink }"
else
    echo "Start building MQTT-SN Gateway"
    
    SCRIPT_DIR=$(cd $(dirname $0); pwd)
    cd $SCRIPT_DIR/..
    rm -rf build.gateway
    mkdir build.gateway
    cd build.gateway
    cmake .. -DSENSORNET=$1
    make MQTTSNPacke
    make MQTT-SNGateway
    make MQTT-SNLogmonitor
fi