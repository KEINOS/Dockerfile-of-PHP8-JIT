ARG BASE_IMAGE='keinos/php8-jit:latest'

FROM ${BASE_IMAGE}

USER root

COPY ./tests /app/tests

WORKDIR /app

# Install deps and extensions
RUN \
    # Enable YAML
    apk --no-cache add yaml-dev && \
    docker-php-ext-pecl install yaml

# Install composer
RUN \
    echo '- Installing composer ...' && \
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"; \
    [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ] && { >&2 echo 'ERROR: Invalid installer signature'; exit 1; }; \
    php composer-setup.php --quiet --install-dir=/bin --filename=composer && \
    composer --version && \
    rm composer-setup.php

# Install composer packages
RUN \
    composer require --ignore-platform-reqs \
        phpunit/phpunit \
        rybakit/msgpack \
    && \
    ./vendor/bin/phpunit --version

ENTRYPOINT [ "/app/vendor/bin/phpunit", "--testdox", "./tests" ]
