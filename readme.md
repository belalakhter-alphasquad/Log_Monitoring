## Usage

Before that,

- In docker compose file section for fluent bit verify the path for log files
- In the fluent bit config verify the input file paths match with docker compose
- In the pipeline.yaml verify the Index name avoid Camel Case

## Run with Docker

Use `docker compose up -d`

Wait for 30 seconds for successful setup

## Data Prepper

Run this command to setup log ingestion pipeline

`docker run --name data-prepper -v ${PWD}/pipeline.yaml:/usr/share/data-prepper/pipelines/pipeline.yaml --network "log_monitoring_opensearch-net" opensearchproject/data-prepper:latest`

## Update logs

update log files using :

`echo '63.173.168.120 - - [04/Nov/2021:15:07:25 -0500] "GET /search/tag/list HTTP/1.0" 200 5003' >> test1.log`

also the if multiple files

`echo '63.173.168.120 - - [04/Nov/2021:15:07:25 -0500] "GET /search/tag/list HTTP/1.0" 200 5003' >> test2.log`

The changes will reflect in the newly index created and can be visulaized on Dashboard.
