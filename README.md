CHN-Server
==========

*Community Honey Network server*
[![Join the chat at https://gitter.im/CommunityHoneyNetwork/community](https://badges.gitter.im/CommunityHoneyNetwork/community.svg)](https://gitter.im/CommunityHoneyNetwork/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Find the documentation here: [https://communityhoneynetwork.readthedocs.io](https://communityhoneynetwork.readthedocs.io)

![CI](https://github.com/CommunityHoneyNetwork/CHN-Server/workflows/CI/badge.svg)

## Repository Structure

- `/images/cowrie`: The patched cowrie image
- `/templates`: Templates from [quickstart](https://github.com/CommunityHoneyNetwork/chn-quickstart)
- `/ddos`: Exploration on DDoS attacks
- `/mhn`: Source code
- `/scripts`: Scripts for deploying instances
- `/utils`: Scripts to help with `docker compose` for multiple instances

## Guide

### Setting up .env files

The `templates` directory includes template `.env` files for configuration. See `chn-quickstart` for how to configure easily the server.
Create a folder called `config/sysconfig` and move your environment files.

The structure of the config/sysconfig directory should look like this:
```sh
config
└── sysconfig
    ├── chnserver.env
    ├── hpfeeds-logger.env
    └── mnemosyne.env
``` 

- An example configuration for `mnemosyne.env` is:
```sh
# This can be modified to change the default setup of the unattended installation

HPFEEDS_HOST=hpfeeds3
HPFEEDS_PORT=10000

MONGODB_HOST=mongodb
MONGODB_PORT=27017

# MONGODB_INDEXTTL sets the number of seconds to keep data in the mongo database
# This default value is 30 days
MONGODB_INDEXTTL=2592000

IGNORE_RFC1918=False
```

- An example configuration for `hpfeeds-logger` is:
```sh
# Defaults here are for containers, but can be adjusted
# after install for a regular server or to customize the containers

MONGODB_HOST=mongodb
MONGODB_PORT=27017

# Log to local file; the path is internal to the container and the host filesystem
# location is controlled by volume mapping in the docker-compose.yml
FILELOG_ENABLED=true
LOG_FILE=/var/log/hpfeeds-logger/chn.log

# Choose to rotate the log file based on 'size'(default) or 'time'
ROTATION_STRATEGY=size

# If rotating by 'size', the number of MB to rotate at
ROTATION_SIZE_MAX=100

# If rotating by 'time', the unit to count in; valid values are "m","h", and "d"
ROTATION_TIME_UNIT=h

# If rotating by 'time', the number of hours to rotate at
ROTATION_TIME_MAX=24

# Log to syslog
SYSLOG_ENABLED=false
SYSLOG_HOST=localhost
SYSLOG_PORT=514
SYSLOG_FACILITY=user

# Options are arcsight, json, raw_json, splunk
FORMATTER_NAME=json

# To log data from an external HPFeeds stream, uncomment and fill out these
# variables. Additionally, change the HPFEEDS_* variables to point to the
# remote service.

IDENT=hpfeeds-logger-85jGNmLL
# SECRET=
# CHANNELS=

HPFEEDS_HOST=hpfeeds3
HPFEEDS_PORT=10000
```

- An example configuration for `chn-server` is:
```sh
# Generated from generate_chn_sysconfig.py
# This can be modified to change the default setup of the chnserver unattended
# installation

DEBUG=false

EMAIL=admin@localhost
# For TLS support, you MUST set SERVER_BASE_URL to "https://your.site.tld"
SERVER_BASE_URL=https://0.0.0.0/chn
MAIL_SERVER=127.0.0.1
MAIL_PORT=25
MAIL_TLS=y
MAIL_SSL=y
MAIL_USERNAME=
MAIL_PASSWORD=
DEFAULT_MAIL_SENDER=
MONGODB_HOST=mongodb
MONGODB_PORT=27017
HPFEEDS_HOST=hpfeeds3
HPFEEDS_PORT=10000

SUPERUSER_EMAIL=admin@localhost
SUPERUSER_PASSWORD=SUPER_STRONG_PASSWORD_REPLACE_THIS
SECRET_KEY=
DEPLOY_KEY=

# See https://communityhoneynetwork.readthedocs.io/en/stable/certificates/
# Options are: 'CERTBOT', 'SELFSIGNED', 'BYO'
CERTIFICATE_STRATEGY=SELFSIGNED
```

### Building

To make sure you have a clean build, navigate to the root directory of the git project and run:
```sh
docker compose up --build -d 
```
*Warning*: The `mnemosyne` service is a bit slow.

### Deploying honeypots

- Create a folder called `deploy` and go to the created directory
```sh
mkdir -p deploy
cd deploy
```
- Copy the `utils` scripts to `deploy`
```sh
cp -r ../utils/* .
```
- Download your deploy scripts in that directory from the interface of chn-network

- The command displayed in the chn-network `Deploy` page on the `replicas` dropdown option, with `Instances` chosen to `20`, would look like this:

```sh
wget --no-check-certificate "https://0.0.0.0/chn/api/script/?text=true&script_id=1" -O deploy_KEY.sh && bash deploy_KEY.sh -d "DEPLOY_KEY" -i "20" -k <API_KEY> && docker compose up -d
```

To `compose up` all the containers, instead of `docker compose up -d`, use the script from `utils` with optional argument the instances (defaults to 10)
```sh
# Specifying number of instances
compose_up.sh 20
```

If you want to remove all the containers and their volumes, use:
```sh
# Specifying the number of instances
compose_down.sh 20
```

If there are issues with the container port mapped ranges, you can modify them to map to a different range. The port range may start to get out of hand as the number of instances grow.

## TODO

- [x] Add replicas support (good for automation) `or` generate multiple compose files: *cowrie-1*, *cowrie-2* with increasing assigned range. I already have some silly scripts that I can improve.
- [x] See issue with deploy-key `or` maybe remove the deploy-key entirely. (There is no reason for that).
- [x] Set default config for `cowrie` for ease of testing.
- [x] Try out CnC with CHN-Server
- [-] Choose a DDoS approach
- [ ] Try out the DDoS along with CnC and CHN-Server
- [x] Enrich documentation and steps for reproducibility