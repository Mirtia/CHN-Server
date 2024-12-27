#!/bin/bash

INSTANCE_COUNT=${1:-10}

for ((i=1; i<=INSTANCE_COUNT; i++)); do
  echo "Starting instance $i..."
  docker compose -f docker-compose-${i}.yml up -d
done

echo "All instances are up and running."