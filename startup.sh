docker-compose up -d opensearch opensearch-dashboards data-prepper


sleep 30

sudo docker exec -it opensearch ./securityadmin_demo.sh

sleep 60

docker-compose up -d
