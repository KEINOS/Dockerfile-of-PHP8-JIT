ARG NAME_IMAGE

FROM ${NAME_IMAGE}

USER root

ARG PHP_ENABLE_PRELOAD=1

COPY . /app

RUN \
    [ $PHP_ENABLE_PRELOAD -ne 0 ] && \
    { echo 'Enabling preload'; cp /app/docker-php-enable-preload.ini /usr/local/etc/php/conf.d/docker-php-enable-preload.ini; } || \
    { echo 'Disabling prelosd'; }; \
    mkdir -p /tmp/php/opcache

WORKDIR /app

RUN php /app/bench.php

ENTRYPOINT [ "/bin/sh", "/app/entrypoint.sh" ]
