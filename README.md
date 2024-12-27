CHN-Server
==========

*Community Honey Network server*
[![Join the chat at https://gitter.im/CommunityHoneyNetwork/community](https://badges.gitter.im/CommunityHoneyNetwork/community.svg)](https://gitter.im/CommunityHoneyNetwork/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Find the documentation here: [https://communityhoneynetwork.readthedocs.io](https://communityhoneynetwork.readthedocs.io)

![CI](https://github.com/CommunityHoneyNetwork/CHN-Server/workflows/CI/badge.svg)

## TODO

- [x] Add replicas support (good for automation) `or` generate multiple compose files: *cowrie-1*, *cowrie-2* with increasing assigned range. I already have some silly scripts that I can improve.
- [x] See issue with deploy-key `or` maybe remove the deploy-key entirely. (There is no reason for that).
- [x] Set default config for `cowrie` for ease of testing.
- [ ] [Known hosts for the containers](https://www.linkedin.com/pulse/learn-how-access-docker-container-its-name-from-host-renato-rodrigues/) May be useful when trying out the botnet.

## Guide

- Create a folder called `deploy` and go to the created directory
```sh
mkdir -p deploy
cd deploy
```
- Copy the `utils` scripts to `deploy`
```sh
cp -r ../utils/ .
```
- Download your deploy scripts in that directory from the interface of chn-network