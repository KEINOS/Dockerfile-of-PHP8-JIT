#!/bin/sh

echo
echo '- Build Enabled'
docker build \
    --no-cache \
    --build-arg NAME_IMAGE='keinos/php8-jit:latest' \
    --build-arg PHP_ENABLE_PRELOAD=1 \
    -t test:enabled \
    .
echo

echo
echo '- Build Disabled'
docker build \
    --no-cache \
    --build-arg NAME_IMAGE='keinos/php8-jit:latest' \
    --build-arg PHP_ENABLE_PRELOAD=0 \
    -t test:disabled \
    .
echo

clear

echo
echo '=================================='
echo ' Running tests (Preload Enabled)'
echo '=================================='
docker run --rm test:enabled

echo
echo '=================================='
echo ' Running tests (Preload Disabled)'
echo '=================================='
docker run --rm test:disabled
