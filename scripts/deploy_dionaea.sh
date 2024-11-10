#!/bin/bash

# https://chn-server-chnserver where chn-server-chnserver is the docker container service name
URL="https://chn-server-chnserver"
# chn-server-hpfeeds3 is the docker container service name
FEEDS_SERVER="chn-server-hpfeeds3"
VERSION="1.9.1"
TAGS=""
ARCH=""

while getopts ":u:d:a:k:f:h" opt; do
  case ${opt} in
    u ) URL=$OPTARG ;;
    d ) DEPLOY=$OPTARG ;;
    a ) ARCH=$OPTARG ;;
    k ) API_KEY=$OPTARG ;;
    f ) FEEDS_SERVER=$OPTARG ;;
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

echo 'Creating docker compose.yml...'
cat << EOF > ./docker-compose.yml
services:
  dionaea:
    image: stingar/dionaea${ARCH}:${VERSION}
    restart: always
    volumes:
      - configs:/etc/dionaea/
    ports:
      - "21:21"
      - "23:23"
      - "42:42"
      - "135:135"
      - "445:445"
      - "1433:1433"
      - "1723:1723"
      - "1883:1883"
      - "3306:3306"
      - "5060:5060"
      - "11211:11211"
      - "27017:27017"
    env_file:
      - dionaea.env
    cap_add:
      - NET_ADMIN
    networks:
    - chn-network

volumes:
    configs:

networks:
  chn-network:
    external: true
EOF
echo 'Done!'
echo 'Creating dionaea.env...'
cat << EOF > dionaea.env
# This can be modified to change the default setup of the unattended installation

DEBUG=false

# IP Address of the honeypot
# Leaving this blank will default to the docker container IP
IP_ADDRESS=

CHN_SERVER=${URL}
DEPLOY_KEY=${DEPLOY}

# Network options
LISTEN_ADDRESSES=0.0.0.0
LISTEN_INTERFACES=eth0


# Service options
# blackhole, epmap, ftp, http, memcache, mirror, mongo, mqtt, mssql, mysql, pptp, sip, smb, tftp, upnp
SERVICES=(blackhole epmap ftp http memcache mirror mongo mqtt pptp sip smb tftp upnp)

DIONAEA_JSON=/etc/dionaea/dionaea.json

# Logging options
HPFEEDS_ENABLED=true
FEEDS_SERVER=${FEEDS_SERVER}
FEEDS_SERVER_PORT=10000

# Comma separated tags for honeypot
TAGS=${TAGS}

# A specific "personality" directory for the dionaea honeypot may be specified
# here. These directories can include custom dionaea.cfg and service configurations
# files which can influence the attractiveness of the honeypot.
PERSONALITY=""

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
