# DESCRIPTION       Pinpoint APM Collector
# TO_BUILD          docker build -t pinpoint-collector .
# TO_RUN            docker run -d --net=host -e HBASE_HOST=<HOST_IP> -e HBASE_PORT=2181 -e COLLECTOR_TCP_PORT=9994 -e COLLECTOR_UDP_STAT_LISTEN_PORT=9995 -e COLLECTOR_UDP_SPAN_LISTEN_PORT=9996 -p 9994:9994 -p 9995:9995/udp -p 9996:9996/udp --name=pinpoint-collector pinpoint-collector

FROM tomcat:8-jre8

ENV PINPOINT_VERSION=1.7.0

ADD start-collector.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/start-collector.sh && mkdir -p /assets

COPY pinpoint-collector.war /assets/

RUN rm -rf /usr/local/tomcat/webapps \
    && mkdir -p /usr/local/tomcat/webapps \
    && sed -i -e 's/8005/9005/' /usr/local/tomcat/conf/server.xml \
    && sed -i -e 's/8080/9080/' /usr/local/tomcat/conf/server.xml \
    && sed -i -e 's/8009/9009/' /usr/local/tomcat/conf/server.xml \
    && sed -i -e 's/8443/9443/' /usr/local/tomcat/conf/server.xml \
    && cd /assets && unzip pinpoint-collector.war -d /usr/local/tomcat/webapps/ROOT \
    && rm -rf pinpoint-collector.war

EXPOSE 9994 9995 9996

ENTRYPOINT ["/usr/local/bin/start-collector.sh"]
