#!/bin/bash

URL=$1
DEPLOY=$2
ARCH=$3
SERVER=$(echo ${URL} | awk -F/ '{print $3}')
VERSION=1.9.1
TAGS=""

echo 'Creating docker compose.yml...'
cat << EOF > ./docker compose.yml
version: '3'
services:
    conpot:
        image: stingar/conpot${ARCH}:${VERSION}
        restart: always
        volumes:
            - configs:/etc/conpot
        ports:
            - "80:8800"
            - "102:10201"
            - "502:5020"
            - "21:2121"
            - "44818:44818"
        env_file:
            - conpot.env
volumes:
    configs:
EOF
echo 'Done!'
echo 'Creating conpot.env...'
cat << EOF > conpot.env
# This can be modified to change the default setup of the unattended installation

DEBUG=false

# IP Address of the honeypot
# Leaving this blank will default to the docker container IP
IP_ADDRESS=

# CHN Server api to register to
CHN_SERVER=${URL}

# Server to stream data to
FEEDS_SERVER=${SERVER}
FEEDS_SERVER_PORT=10000

# Deploy key from the FEEDS_SERVER administrator
# This is a REQUIRED value
DEPLOY_KEY=${DEPLOY}

# Registration information file
# If running in a container, this needs to persist
CONPOT_JSON=/etc/conpot/conpot.json

# Conpot specific configuration options
CONPOT_TEMPLATE=default

# Comma separated tags for honeypot
TAGS=${TAGS}
EOF
echo 'Done!'
echo ''
echo ''
echo 'Type "docker compose ps" to confirm your honeypot is running'
echo 'You may type "docker compose logs" to get any error or informational logs from your honeypot'
