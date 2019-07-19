#!/bin/bash

# Run this script locally to compare speed between
#   - php5.6.40
#   - php7.3.6
#   - php8.0.0 with no JIT enabled
#   - php8.0.0 with JIT enabled

#name_test='test-fibonacci.php'
name_test='test-zundoko.php'

name_image_php5='php:5.6.40-alpine'
name_image_php7_1='php:7.1.23-alpine'
name_image_php7_3='php:7.3.6-alpine'
name_image_php8noJit='akondas/php:8.0-cli-alpine'
name_image_php8jit='php:8.0-jit'

echo '============='
echo ' Preparation '
echo '============='

echo '- Pulling images'
docker pull $name_image_php5 && \
docker pull $name_image_php7_1 && \
docker pull $name_image_php7_3 && \
docker pull $name_image_php8noJit

docker image ls | grep php | grep 8.0-jit 2>&1 > /dev/null
if [ $? -ne 0 ]; then
  echo '- PHP8 JIT not found'
  echo '- Building image of PHP8 with JIT ... '
  docker build --no-cache -t $name_image_php8jit . 2>&1 > /dev/null
  if [ $? -ne 0 ]; then
    echo 'NG. Failed to build image.'
    exit 1
  fi
fi

echo '==============='
echo ' Running Tests '
echo '==============='

echo '- Run test in PHP5 (Docker)'
docker run --rm \
  -v $(pwd)/test:/usr/src/app \
  -w /usr/src/app \
  $name_image_php5 \
  php $name_test

echo '- Run test in PHP7.1 (Local)'
php test/$name_test

echo '- Run test in PHP7.1 (Docker)'
docker run --rm \
  -v $(pwd)/test:/usr/src/app \
  -w /usr/src/app \
  $name_image_php7_1 \
  php $name_test

echo '- Run test in PHP7.3 (Docker)'
docker run --rm \
  -v $(pwd)/test:/usr/src/app \
  -w /usr/src/app \
  $name_image_php7_3 \
  php $name_test

echo '- Run test in PHP8 with NO JIT (Docker)'
docker run --rm \
  -v $(pwd)/test:/usr/src/app \
  -w /usr/src/app \
  $name_image_php8noJit \
  php $name_test

echo '- Run test in PHP8 with JIT' && \
docker run --rm \
  -v $(pwd)/test:/usr/src/app \
  -w /usr/src/app \
  $name_image_php8jit \
  php $name_test
