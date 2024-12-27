#!/bin/bash

# https://chn-server-chnserver where chn-server-chnserver is the docker container service name
URL="https://chn-server"
# chn-server-hpfeeds3 is the docker container service name
FEEDS_SERVER="chn-hpfeeds3"
VERSION="1.9.1"
TAGS=""
ARCH=""

while getopts ":u:d:k:f:h" opt; do
  case ${opt} in
    u ) URL=$OPTARG ;;
    d ) DEPLOY=$OPTARG ;;
    a ) ARCH=$OPTARG ;;
    k ) API_KEY=$OPTARG ;;
    f ) FEEDS_SERVER=$OPTARG ;;
    h )
      echo "Usage: $0 -d DEPLOY -k API_KEY [-u URL] [-f FEEDS_SERVER]"
      exit 0 ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $0 -d DEPLOY -k API_KEY [-u URL] [-f FEEDS_SERVER]"
      exit 1 ;;
    : )
      echo "Option -$OPTARG requires an argument." >&2
      echo "Usage: $0 -d DEPLOY -k API_KEY [-u URL] [-f FEEDS_SERVER]"
      exit 1 ;;
  esac
done

if [ -z "$DEPLOY" ]; then
  echo "Error: DEPLOY (-d) is required."
  echo "Usage: $0 -d DEPLOY -k API_KEY [-u URL] [-f FEEDS_SERVER]"
  exit 1
fi

if [ -z "$API_KEY" ]; then
  echo "Error: API_KEY (-k) is required."
  echo "Usage: $0 -d DEPLOY -k API_KEY [-u URL] [-f FEEDS_SERVER]"
  exit 1
fi

echo 'Creating docker-compose.yml...'
cat << EOF > ./docker-compose.yml
services:
  cowrie:
    image: mirtia/chn-cowrie:${VERSION}
    restart: always
    volumes:
      - configs:/etc/cowrie
      - ./data:/data
    ports:
      - "2222:2222"
      - "23:2223"
    env_file:
      - cowrie.env
    networks:
      - chn-network

volumes:
    configs:

networks:
  chn-network:
    external: true
EOF
echo 'Done!'
echo 'Creating cowrie.env...'
cat << EOF > cowrie.env
# This can be modified to change the default setup of the unattended installation

DEBUG=false

# IP Address of the honeypot
# Leaving this blank will default to the docker container IP
IP_ADDRESS=

# CHN Server api to register to
CHN_SERVER=${URL}

# Server to stream data to
FEEDS_SERVER=${FEEDS_SERVER}
FEEDS_SERVER_PORT=10000

# Deploy key from the FEEDS_SERVER administrator
# This is a REQUIRED value
DEPLOY_KEY=${DEPLOY}

# Registration information file
# If running in a container, this needs to persist
COWRIE_JSON=/etc/cowrie/cowrie.json

# SSH Listen Port
# Can be set to 22 for deployments on real servers
# or left at 2222 and have the port mapped if deployed
# in a container
SSH_LISTEN_PORT=2222

# Telnet Listen Port
# Can be set to 23 for deployments on real servers
# or left at 2223 and have the port mapped if deployed
# in a container
TELNET_LISTEN_PORT=2223

# double quotes, comma delimited tags may be specified, which will be included
# as a field in the hpfeeds output. Use cases include tagging provider
# infrastructure the sensor lives in, geographic location for the sensor, etc.
TAGS=${TAGS}

# A specific "personality" directory for the Cowrie honeypot may be specified
# here. These directories can include custom fs.pickle, cowrie.cfg, txtcmds and
# userdb.txt files which can influence the attractiveness of the honeypot.
PERSONALITY=default

# Configure your dionaea honeypot to upload any files downloaded from attackers to an S3-compatible object store
S3_OUTPUT_ENABLED=false
S3_ACCESS_KEY=access_key
S3_SECRET_KEY=secret_key
S3_ENDPOINT=https://s3_server/bucket
S3_VERIFY=True

# Add API_KEY for REST API
API_KEY=${API_KEY}

EOF
echo 'Done!'
echo ''
echo ''
echo 'Type "docker compose ps" to confirm your honeypot is running'
echo 'You may type "docker compose logs" to get any error or informational logs from your honeypot'
