#!/bin/sh

## Builds war via a Docker container

docker run -it --rm --name envinfo-docker-builder \
  --volume $(pwd):/usr/src/envinfo:z \
  --workdir /usr/src/envinfo \
  jruby:9-alpine sh -c 'bundle install && warble && echo DONE'

