#
# Sample usage to install extensions of msgpack PECL package from source.
#
# - About MessagePack:
#   MessagePack is an efficient binary serialization format. It lets you exchange
#   data among multiple languages like JSON. But it's faster and smaller. Small
#   integers are encoded into a single byte, and typical short strings require
#   only one extra byte in addition to the strings themselves.
#
# - For more details see: https://msgpack.org/
#
# - How to run sample
#   $ docker build -t test:local .
#   $ docker run --rm test:local
#
FROM keinos/php8-jit

USER root

COPY sample.php /app/sample.php

WORKDIR /app

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

RUN \
    composer require rybakit/msgpack

ENTRYPOINT [ "php", "/app/sample.php" ]
