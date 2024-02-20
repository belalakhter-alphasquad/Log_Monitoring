#!/bin/bash

# Define the hostname or IP address of your Data Prepper service
DATA_PREPPER_HOST="data-prepper"

# Define the port number Data Prepper is listening on
DATA_PREPPER_PORT="4900"

# Check if Data Prepper is reachable on the specified host and port
while ! nc -z "$DATA_PREPPER_HOST" "$DATA_PREPPER_PORT"; do
  echo "Waiting for Data Prepper to become available..."
  sleep 5
done

echo "Data Prepper is up and running on port $DATA_PREPPER_PORT. Starting Fluent Bit..."

# Replace this command with the command to start Fluent Bit, including any necessary flags or config file paths.
/fluent-bit/bin/fluent-bit -c /fluent-bit/etc/fluent-bit.conf
