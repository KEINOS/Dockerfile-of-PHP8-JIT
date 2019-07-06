FROM akondas/php:8.0-cli-alpine

COPY docker-php-enable-jit.ini /usr/local/etc/php/conf.d/docker-php-enable-jit.ini

HEALTHCHECK \
  --interval=60m \
  --timeout=10s \
  --start-period=10m \
  --retries=1 CMD [ 'php -r "echo phpversion();"' ]

USER www-data
