#!/bin/bash

# https://chn-server-chnserver where chn-server-chnserver is the docker container service name
URL="https://chn-server-chnserver"
# chn-server-hpfeeds3 is the docker container service name
FEEDS_SERVER="chn-server-hpfeeds3"
VERSION="1.9.1"
TAGS=""
ARCH=""

while getopts ":u:d:a:k:f:i:h" opt; do
  case ${opt} in
    u ) URL=$OPTARG ;;
    d ) DEPLOY=$OPTARG ;;
    a ) ARCH=$OPTARG ;;
    k ) API_KEY=$OPTARG ;;
    f ) FEEDS_SERVER=$OPTARG ;;
    i ) INSTANCE_COUNT=$OPTARG ;;
    h )
      echo "Usage: $0 -d DEPLOY -a ARCH -k API_KEY [-u URL] [-f FEEDS_SERVER]"
      exit 0 ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $0 -d DEPLOY -a ARCH -k API_KEY [-u URL] [-f FEEDS_SERVER]"
      exit 1 ;;
    : )
      echo "Option -$OPTARG requires an argument." >&2
      echo "Usage: $0 -d DEPLOY -a ARCH -k API_KEY [-u URL] [-f FEEDS_SERVER]"
      exit 1 ;;
  esac
done

if [ -z "$DEPLOY" ]; then
  echo "Error: DEPLOY (-d) is required."
  echo "Usage: $0 -d DEPLOY -a ARCH -k API_KEY [-u URL] [-f FEEDS_SERVER]"
  exit 1
fi

if [ -z "$API_KEY" ]; then
  echo "Error: API_KEY (-k) is required."
  echo "Usage: $0 -d DEPLOY -a ARCH -k API_KEY [-u URL] [-f FEEDS_SERVER]"
  exit 1
fi

for ((i=1; i<=INSTANCE_COUNT; i++)); do
  echo "Creating docker-compose-${i}.yml..."
  cat << EOF > ./docker-compose-${i}.yml
services:
  dionaea-${i}:
    image: stingar/dionaea${ARCH}:${VERSION}
    restart: always
    volumes:
      - configs-${i}:/etc/dionaea/
    ports:
      - "$((121 + i)):21"
      - "$((1123 + i)):23"
      - "$((42 + i)):42"
      - "$((135 + i)):135"
      - "$((445 + i)):445"
      - "$((1433 + i)):1433"
      - "$((1723 + i)):1723"
      - "$((1883 + i)):1883"
      - "$((3306 + i)):3306"
      - "$((5060 + i)):5060"
      - "$((11211 + i)):11211"
      - "$((27017 + i)):27017"
    env_file:
      - dionaea-${i}.env
    cap_add:
      - NET_ADMIN
    networks:
      - chn-network

volumes:
    configs-${i}:

networks:
  chn-network:
    external: true
EOF

  echo "Creating dionaea-${i}.env..."
  cat << EOF > dionaea-${i}.env
DEBUG=false

# IP Address of the honeypot
IP_ADDRESS=

CHN_SERVER=${URL}
DEPLOY_KEY=${DEPLOY}

# Network options
LISTEN_ADDRESSES=0.0.0.0
LISTEN_INTERFACES=eth0

# Service options
SERVICES=(blackhole epmap ftp http memcache mirror mongo mqtt pptp sip smb tftp upnp)

DIONAEA_JSON=/etc/dionaea/dionaea.json

# Logging options
HPFEEDS_ENABLED=true
FEEDS_SERVER=${FEEDS_SERVER}
FEEDS_SERVER_PORT=10000

# Tags for the honeypot
TAGS=${TAGS}

# "Personality" directory for customization
PERSONALITY=""

# Configure S3-compatible object store for file uploads
S3_OUTPUT_ENABLED=false
S3_ACCESS_KEY=access_key
S3_SECRET_KEY=secret_key
S3_ENDPOINT=https://s3_server/bucket
S3_VERIFY=True

# API Key for REST API
API_KEY=${API_KEY}
EOF
done

echo 'Done!'
echo "Created ${INSTANCE_COUNT} instances."
echo ''
echo 'Use "docker compose -f docker-compose-<instance_number>.yml up" to start each honeypot instance.'
echo 'Type "docker compose ps" to confirm your honeypot instances are running'
