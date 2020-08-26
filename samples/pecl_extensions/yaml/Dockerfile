#
# Sample usage to install extensions of PECL package from source
#
FROM keinos/php8-jit

USER root

COPY sample.php /app/sample.php

RUN \
    # Install dependencies before pecl
    apk --no-cache add yaml-dev && \
    # Install PECL package from source
    docker-php-ext-pecl install yaml

ENTRYPOINT [ "php", "/app/sample.php" ]
