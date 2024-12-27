#!/bin/bash

INSTANCE_COUNT=${1:-10}

for ((i=1; i<=INSTANCE_COUNT; i++)); do
  echo "Stopping instance $i..."
  docker compose -f docker-compose-${i}.yml down
done

echo "All instances have been stopped and removed."