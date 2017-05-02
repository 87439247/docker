# DESCRIPTION       Pinpoint APM Web (User Interface)
# TO_BUILD          docker build -t pinpoint-web .
# TO_RUN            docker run -d -p 8080:8080 --net=host -e HBASE_HOST=<HOST_IP> -e HBASE_PORT=2181 --name=pinpoint-web pinpoint-web

FROM tomcat:8-jre8

ENV PINPOINT_VERSION=1.7.0

ADD start-web.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/start-web.sh && mkdir -p /assets/

COPY pinpoint-web.war /assets/

RUN rm -rf /usr/local/tomcat/webapps \
    && mkdir -p /usr/local/tomcat/webapps \
    && cd /assets && unzip pinpoint-web.war -d /usr/local/tomcat/webapps/ROOT \
    && rm -rf pinpoint-web.war

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/start-web.sh"]

