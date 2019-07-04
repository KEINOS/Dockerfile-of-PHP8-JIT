FROM akondas/php:8.0-cli-alpine

COPY docker-php-enable-jit.ini /usr/local/etc/php/conf.d/docker-php-enable-jit.ini
