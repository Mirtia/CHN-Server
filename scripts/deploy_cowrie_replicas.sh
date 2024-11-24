#!/bin/bash

# https://chn-server-chnserver where chn-server-chnserver is the docker container service name
URL="https://chn-server"
# chn-server-hpfeeds3 is the docker container service name
FEEDS_SERVER="chn-hpfeeds3"
VERSION="1.9.1"
TAGS=""
ARCH=""
# Default instance count
INSTANCE_COUNT=10

while getopts ":u:d:a:k:f:i:h" opt; do
  case ${opt} in
    u ) URL=$OPTARG ;;
    d ) DEPLOY=$OPTARG ;;
    a ) ARCH=$OPTARG ;;
    k ) API_KEY=$OPTARG ;;
    f ) FEEDS_SERVER=$OPTARG ;;
    i ) INSTANCE_COUNT=$OPTARG ;;
    h )
      echo "Usage: $0 -d DEPLOY -a ARCH -k API_KEY -i INSTANCE_COUNT  [-u URL] [-f FEEDS_SERVER]"
      exit 0 ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $0 -d DEPLOY -a ARCH -k API_KEY -i INSTANCE_COUNT  [-u URL] [-f FEEDS_SERVER]"
      exit 1 ;;
    : )
      echo "Option -$OPTARG requires an argument." >&2
      echo "Usage: $0 -d DEPLOY -a ARCH -k API_KEY -i INSTANCE_COUNT  [-u URL] [-f FEEDS_SERVER]"
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
  # Create a docker-compose file and .env for each instance
  cat << EOF > ./docker-compose-${i}.yml
services:
  cowrie-${i}:
    image: mirtia/chn-cowrie${ARCH}:${VERSION}
    restart: always
    volumes:
      - configs${i}:/etc/cowrie
    ports:
      - "$((2222 + i)):2222"
      - "$((23 + i)):2223"
    env_file:
      - cowrie-${i}.env
    networks:
      - chn-network

volumes:
  configs${i}:

networks:
  chn-network:
    external: true
EOF

  cat << EOF > cowrie-${i}.env
DEBUG=false
IP_ADDRESS=
CHN_SERVER=${URL}
FEEDS_SERVER=${FEEDS_SERVER}
FEEDS_SERVER_PORT=10000
DEPLOY_KEY=${DEPLOY}
COWRIE_JSON=/etc/cowrie/cowrie.json
SSH_LISTEN_PORT=2222
TELNET_LISTEN_PORT=2223
TAGS=${TAGS}
PERSONALITY=default
S3_OUTPUT_ENABLED=false
S3_ACCESS_KEY=access_key
S3_SECRET_KEY=secret_key
S3_ENDPOINT=https://s3_server/bucket
S3_VERIFY=True
API_KEY=${API_KEY}
EOF
done


echo 'Done!'
echo 'Use "docker compose -f docker-compose-<instance_number>.yml up" to start each honeypot instance.'
echo 'Type "docker compose ps" to confirm your honeypot instances are running'
