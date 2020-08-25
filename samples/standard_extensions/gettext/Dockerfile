#
# Sample usage to install standard extensions.
#
# Ref: https://github.com/docker-library/php/issues/326#issuecomment-258032522
#
FROM keinos/php8-jit

# To install extensions you need a root privilege (Default is: www-data)
USER root

COPY ./src /app

RUN \
    # gettext extension requires gettext-dev for x86_64
    # See: https://pkgs.alpinelinux.org/contents?file=libintl.h&branch=v3.4&arch=x86_64
    apk --no-cache add gettext-dev && \
    # Install gettext extension
    docker-php-ext-install gettext

ENTRYPOINT [ "php", "/app/sample.php" ]
