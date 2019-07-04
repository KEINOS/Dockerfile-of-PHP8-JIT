#!/bin/bash

echo '============='
echo ' Preparation '
echo '============='

echo '- Pulling images'
docker pull php:7.3.6-alpine
docker pull akondas/php:8.0-cli-alpine

echo '==============='
echo ' Running Tests '
echo '==============='

echo '- Run test in PHP7'
docker run --rm \
  -it \
  -v $(pwd)/test:/usr/src/app \
  -w /usr/src/app \
  php:7.3.6-alpine \
  php test-fibonacci.php

echo '- Run test in PHP8 with NO JIT'
docker run --rm \
  -it \
  -v $(pwd)/test:/usr/src/app \
  -w /usr/src/app \
  akondas/php:8.0-cli-alpine \
  php test-fibonacci.php

name_image='php8-jit:test'
docker build --no-cache -t $name_image . 2>&1 > /dev/null && \
echo '- Run test in PHP8 with JIT' && \
docker run --rm \
  -it \
  -v $(pwd)/test:/usr/src/app \
  -w /usr/src/app \
  $name_image \
  php test-fibonacci.php

docker image rm $name_image 2>&1 > /dev/null
