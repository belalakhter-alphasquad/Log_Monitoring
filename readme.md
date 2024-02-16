### Before start

Run these commands

`sudo sysctl -w vm.max_map_count=512000`

`bash generate-certs.sh`

### Opensearch setup

Run Docker compose to setup opean search

`docker compose up -d`

OR

`docker-compose up -d`

Use this command to use security admin plugin to finish certification attachments

`sudo docker compose exec os01 bash -c "chmod +x plugins/opensearch-security/tools/securityadmin.sh && bash plugins/opensearch-security/tools/securityadmin.sh -cd config/opensearch-security -icl -nhnv -cacert config/certificates/ca/ca.pem -cert config/certificates/ca/admin.pem -key config/certificates/ca/admin.key -h localhost"`

### Note usage for configuring log paths
