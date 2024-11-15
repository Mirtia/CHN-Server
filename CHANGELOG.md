
# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
This is not a real changelog. We just use it to keep track of what changes we 
made to the original repository as this is a forked one.
 
## [Unreleased] - 2024-11-10
 
Here we write upgrading notes for brands. It's a team effort to make them as
straightforward as possible.
 
### Added
- Added `/images` directory where the Dockerfile and other necessary files are. Used for building the patched images.
- Added `setup.sh` script for automating the creation of chn-server.
- Added `/templates` folder from `chn-quickstart`.
- Pushed new cowrie image at [Docker Hub](https://hub.docker.com/repository/docker/mirtia/chn-cowrie/general) for `linux/amd64`. 
- Pushed new cowrie image at [Docker Hub](https://hub.docker.com/repository/docker/mirtia/chn-cowrie-arm/general) for `linux/arm/v7`.

### Changed
- Removed all `sudo` related commands from the `manage-deploy` (no reason to specify sudo in any part of the setup). 
- Refactored `docker-compose` with `docker compose` ([See difference](https://stackoverflow.com/questions/66514436/difference-between-docker-compose-and-docker-compose)).
- Added key to the `manage-deploy` view (`/mhn`) for ease of use of the deploy scripts.
- Removed the honeypots we are not interested in from available list (for now).
- Modified the `docker-compose.yml` of chn-server (root directory of the repository). Removed the links, added some hostnames for ease of use.
- Removed `version` from `docker-compose`, as it is not needed.
- Modified the deploy scripts (`/scripts`) to accept the necessary arguments and parameters (`API_KEY`).

### Fixed
- Added `--no-check-certificate` on the `wget` command in the `manage-deploy` view.
- Created a Dockerfile in `/images` for cowrie that pulls the original image `stingar/cowrie` and adds the correct `entrypoint.sh` and `chn-register.py` scripts.