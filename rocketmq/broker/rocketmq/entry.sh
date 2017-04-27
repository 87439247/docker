#!/usr/bin/env bash
if [ ! -f "lock.txt" ]; then
    echo "PATH = $CONF"
    echo "brokerId = $brokerId"
    echo "brokerName = $brokerName"
    echo "namesrvAddr = $namesrvAddr"
    echo "brokerIP1 = $brokerIP1"
    echo "listenPort = $listenPort"
    echo "brokerRole=$brokerRole"

    echo -e "" >> $CONF
    echo -e "brokerId=$brokerId" >> $CONF
    echo -e "brokerName=${brokerName}" >> $CONF
    echo -e "namesrvAddr=${namesrvAddr}" >> $CONF
    echo -e "brokerIP1=${brokerIP1}" >> $CONF
    echo -e "listenPort=${listenPort}" >> $CONF
    echo -e "brokerRole=${brokerRole}" >> $CONF

    touch lock.txt
fi

cd ${ROCKETMQ_HOME}/bin && export JAVA_OPT=" -Duser.home=/opt/data" && sh mqbroker -c ${ROCKETMQ_HOME}/conf/broker.conf