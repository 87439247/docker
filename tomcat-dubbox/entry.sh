#!/usr/bin/env bash

if [ ! ${SERVER_PORT} ]; then
  SERVER_PORT=8080;
fi

SERVER_PORT_SERVER=$[SERVER_PORT+3111];
echo "SERVER_PORT_SERVER=${SERVER_PORT_SERVER}"

SERVER_PORT_REDIRECT=$[SERVER_PORT+3222];
echo "SERVER_PORT_REDIRECT=${SERVER_PORT_REDIRECT}"

SERVER_PORT_AJP=$[SERVER_PORT+3333];
echo "SERVER_PORT_AJP=${SERVER_PORT_AJP}"


if [ ! ${SERVER_NAME} ]; then
  SERVER_NAME=$(hostname);
fi

if [ ! ${JAVA_XMX} ]; then
  JAVA_XMX=3000M;
fi

#echo tomcat/conf/server.xml
SERVER_XML=${CATALINA_HOME}/conf/server.xml
echo "<?xml version='1.0' encoding='utf-8'?>
<Server port=\"${SERVER_PORT_SERVER}\" shutdown=\"SHUTDOWN\">
  <Listener className=\"org.apache.catalina.startup.VersionLoggerListener\" />
  <Listener className=\"org.apache.catalina.core.AprLifecycleListener\" SSLEngine=\"on\" />
  <Listener className=\"org.apache.catalina.core.JasperListener\" />
  <Listener className=\"org.apache.catalina.core.JreMemoryLeakPreventionListener\" />
  <Listener className=\"org.apache.catalina.mbeans.GlobalResourcesLifecycleListener\" />
  <Listener className=\"org.apache.catalina.core.ThreadLocalLeakPreventionListener\" />
  <Service name=\"Catalina\">
    <!--The connectors can use a shared executor, you can define one or more named thread pools-->
    <Executor name=\"tomcatThreadPool\" namePrefix=\"catalina-exec-\" maxThreads=\"512\" minSpareThreads=\"4\"/>
    <Connector executor=\"tomcatThreadPool\"
               port=\"${SERVER_PORT}\"
               enableLookups=\"false\"
               disableUploadTimeout=\"true\"
               acceptCount=\"512\"
               protocol=\"HTTP/1.1\"
               URIEncoding=\"UTF-8\"
               connectionTimeout=\"20000\"
               redirectPort=\"${SERVER_PORT_REDIRECT}\" />
    <!--
    <Connector port=\"${SERVER_PORT_REDIRECT}\" protocol=\"org.apache.coyote.http11.Http11Protocol\"
               maxThreads=\"150\" SSLEnabled=\"true\" URIEncoding=\"UTF-8\" scheme=\"https\" secure=\"true\"
               clientAuth=\"false\" sslProtocol=\"TLS\" />
    -->
    <!-- Define an AJP 1.3 Connector on port 8009 -->
    <Connector port=\"${SERVER_PORT_AJP}\" protocol=\"AJP/1.3\" redirectPort=\"${SERVER_PORT_REDIRECT}\" />
    <Engine name=\"Catalina\" defaultHost=\"localhost\">
      <Host name=\"localhost\" appBase=\"webapps\" unpackWARs=\"true\" autoDeploy=\"true\">
      <Valve className=\"org.apache.catalina.valves.AccessLogValve\"
            directory=\"logs/access\"
            prefix=\"\" suffix=\"_access_log\"
            pattern=\"%{yyyy-MM-dd HH:mm:ss}t ${SERVER_NAME} %p %h %D %m %U %q %s 0 0 &quot;%{User-Agent}i&quot; &quot;%{Referer}i&quot;\"
            fileDateFormat=\"yyyy-MM-dd_HH\"/>
      </Host>
    </Engine>
  </Service>
</Server>" > ${SERVER_XML}

rm -rf ${CATALINA_HOME}/webapps/ROOT
rm -rf ${CATALINA_HOME}/webapps/docs
rm -rf ${CATALINA_HOME}/webapps/examples
rm -rf ${CATALINA_HOME}/webapps/manager
rm -rf ${CATALINA_HOME}/webapps/host-manager


if [ ! ${SERVER_IP} ]; then
    echo "NOT SET SERVER IP"
else
    echo "set hosts start"
    cp /etc/hosts /etc/hosts.temp
    sed -i "s/.*$(hostname)/${SERVER_IP} $(hostname)/" /etc/hosts.temp
    cat /etc/hosts.temp > /etc/hosts
    echo "set hosts end"
fi


export CATALINA_OPTS="
-server
-Xms${JAVA_XMX}
-Xmx${JAVA_XMX}
-Xss512k
-XX:NewSize=1550M
-XX:MaxNewSize=1550M
-XX:+AggressiveOpts
-XX:+UseBiasedLocking
-XX:+DisableExplicitGC
-XX:+UseParNewGC
-XX:+UseConcMarkSweepGC
-XX:+CMSParallelRemarkEnabled
-XX:+UseCMSCompactAtFullCollection
-XX:LargePageSizeInBytes=128m
-XX:+UseFastAccessorMethods
-XX:+UseCMSInitiatingOccupancyOnly
-Duser.timezone=Asia/Shanghai
-Djava.awt.headless=true"


echo "starting tomcat...."
${CATALINA_HOME}/bin/catalina.sh run