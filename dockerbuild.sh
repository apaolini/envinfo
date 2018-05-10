#!/bin/sh

## Builds war via a Docker container

docker run -it --rm --name envinfo-docker-builder \
  -v $(pwd):/usr/src/envinfo:z \
  -w /usr/src/envinfo \
  --user="$(id -u):$(id -g)" \
  jruby:9-alpine sh -c 'bundle install && warble && echo DONE'

