#!/bin/bash

# Run this script locally to compare speed between
#   - php5.6.40
#   - php7.3.6
#   - php8.0.0 with no JIT enabled
#   - php8.0.0 with JIT enabled

# Filenames of the tests to run
list_test=(
  'test-fibonacci.php'
  'test-zundoko.php'
  'test-zend_bench.php'
)

# Docker images to compare. PHP8 with JIT=on will be added later.
list_image=(
  'php:5.6.40-cli-alpine'
  'php:7.0-cli-alpine'
  'php:7.1-cli-alpine'
  'php:7.2-cli-alpine'
  'php:7.3-cli-alpine'
  'php:7.4-cli-alpine'
  'akondas/php:8.0-cli-alpine'
  'keinos/php8-jit:latest'
)

function runTest(){
  name_image=$1
  name_test=$2
  docker run --rm \
    -v $(pwd)/bench:/app \
    -w /app \
    $name_image \
    php $name_test
  return $?
}

echo '============='
echo ' Preparation '
echo '============='

echo '- Clean Up unused images'
docker image prune -f | awk '{print "\t", $0}'

#name_image_php8jit=$(docker image ls --format "{{.Repository}}:{{.Tag}}" | grep php | grep 8 | grep jit | grep keinos)
#if [ $? -ne 0 ]; then
#  name_image_php8jit='php8-jit:local'
#  echo '- PHP8 with JIT=on not found'
#  echo '- Building image of PHP8 with JIT=on ...(This will take time)'
#  docker build --quiet --no-cache -t $name_image_php8jit .
#  if [ $? -ne 0 ]; then
#    echo 'NG. Failed to build image.'
#    exit 1
#  fi
#fi
# Add PHP8 with JIT=on to the image list
#list_image+=($name_image_php8jit)

echo '- Pulling images'
for item in ${list_image[@]}; do
    docker pull $item | awk '{print "\t", $0}'
    echo
done

echo '==============='
echo ' Running Tests '
echo '==============='

for image in ${list_image[@]}; do
  echo '- Image:' $image
  for test in ${list_test[@]}; do
    runTest $image $test | awk '{print "\t", $0}'
  done
done
