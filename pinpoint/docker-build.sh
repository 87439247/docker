#!/usr/bin/env bash
cd pinpoint-hbase
docker build -t "pinpoint-hbase:1.7.0" .

cd ../pinpoint-web
docker build -t "pinpoint-web:1.7.0" .

cd ../pinpoint-collector
docker build -t "pinpoint-collector:1.7.0" .