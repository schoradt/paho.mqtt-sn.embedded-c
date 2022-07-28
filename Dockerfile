FROM ubuntu:22.04 as build-env
RUN apt update
RUN apt install -y build-essential libssl-dev cmake
WORKDIR /app
COPY . .
# Compile the binaries
RUN rm -rf build.paho
RUN mkdir build.paho
RUN cd build.paho && cmake .. -DSENSORNET=udp && make MQTT-SNGateway

FROM ubuntu:22.04
COPY --from=build-env /app/build.paho/MQTTSNPacket/src/libMQTTSNPacket.so /app/
COPY --from=build-env /app/MQTTSNGateway/bin/MQTT-SNGateway /app/
RUN echo $' \n\
GatewayID=1\n\
GatewayName=PahoGateway-01\n\
MaxNumberOfClients=30\n\
KeepAlive=60\n\
\n\
BrokerName=172.17.0.1\n\
BrokerPortNo=1883\n\
BrokerSecurePortNo=8883\n\
\n\
AggregatingGateway=NO\n\
QoS-1=NO\n\
Forwarder=YES\n\
PredefinedTopic=NO\n\
ClientAuthentication=NO\n\
\n\
ClientsList=./clients.conf\n\
PredefinedTopicList=/path/to/your_predefinedTopic.conf\n\
\n\
GatewayPortNo=10000\n\
MulticastPortNo=1883\n\
MulticastIP=225.1.1.1\n\
MulticastTTL=1\n\
\n\
ShearedMemory=NO\n' >> /app/gateway.conf
RUN echo $' \n\
Gateway01,192.168.100.198:20001,forwarder\n\
Gateway02,192.168.100.90:20001,forwarder\n\
Gateway03,192.168.100.29:20001,forwarder\n\
Gateway04,192.168.100.70:20001,forwarder\n\
\n' >> /app/clients.conf
WORKDIR /app
EXPOSE 1883/udp
CMD LD_LIBRARY_PATH=/app /app/MQTT-SNGateway -f gateway.conf 