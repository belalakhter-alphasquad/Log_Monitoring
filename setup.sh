#!/bin/bash

echo "Starting OpenSearch and OpenSearch Dashboards..."
docker-compose up -d opensearch dashboards

echo "Waiting for OpenSearch to be available..."
sleep 10 
until curl -s http://localhost:9200 -o /dev/null; do
    echo "Waiting for OpenSearch..."
    sleep 10
done
echo "OpenSearch is up."

echo "Waiting for OpenSearch Dashboards to be available..."
sleep 10 
until curl -s http://localhost:5601 -o /dev/null; do
    echo "Waiting for OpenSearch Dashboards..."
    sleep 10
done
echo "OpenSearch Dashboards is up."

echo "Starting Data Prepper..."
docker-compose up -d data-prepper

echo "Waiting for Data Prepper to be available..."
sleep 10 
until curl -s http://localhost:4900 -o /dev/null; do
    echo "Waiting for Data Prepper..."
    sleep 10
done
echo "Data Prepper is up."

echo "Starting Fluent Bit..."
docker-compose up -d fluent-bit

echo "Checking all services..."
docker-compose ps
