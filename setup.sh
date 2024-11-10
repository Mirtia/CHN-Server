#!/bin/bash

# Create directory
mkdir -p config/sysconfig

# First configure the .env files
python configure_env.py

# Create external network to skip the naming issues
docker network create chn-network

# Then compose
docker compose up -d --build