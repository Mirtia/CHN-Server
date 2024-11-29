## Cowrie Docker Image

Patched docker image from `stingar/cowrie`.

To pull the docker image for *linux/amd64* or *linux/arm64*:
```sh
docker pull mirtia/chn-cowrie
```

**TODO**: Build for other architectures with buildkit, this is only needed for different architectures

```sh
# After setting up for multiplatform builds
docker buildx build --platform linux/amd64,linux/arm64 -t <registry>/chn-cowrie:1.9.1 --build-arg COWRIE_VERSION=1.9.1 --push .
```