#!/bin/bash

# Create directory
mkdir -p config/sysconfig

# First configure the .env files
python configure_env.py

# Then compose
docker compose up -d