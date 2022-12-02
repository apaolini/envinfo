#!/bin/sh

## Builds war via a Docker container

docker run -it --rm --name envinfo-docker-builder \
  --volume $(pwd):/usr/src/envinfo:z \
  --workdir /usr/src/envinfo \
  --ulimit nofile=122880:122880 \
  docker.io/jruby:9-alpine sh -c 'bundle install && warble && echo DONE'

