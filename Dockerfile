FROM keinos/alpine:latest
# =============================================================================

# Dependencies required for running "phpize"
#   These get automatically installed and removed by "docker-php-ext-*" (unless
#   they're already installed)
ENV PHPIZE_DEPS \
        autoconf \
        dpkg-dev dpkg \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c

# persistent / runtime deps
RUN apk add --no-cache \
        ca-certificates \
        curl \
        tar \
        xz \
# https://github.com/docker-library/php/issues/494
        libressl

# ensure www-data user exists
RUN set -x \
    && addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data
# 82 is the standard uid/gid for "www-data" in Alpine
# https://git.alpinelinux.org/aports/tree/main/apache2/apache2.pre-install?h=3.9-stable
# https://git.alpinelinux.org/aports/tree/main/lighttpd/lighttpd.pre-install?h=3.9-stable
# https://git.alpinelinux.org/aports/tree/main/nginx/nginx.pre-install?h=3.9-stable

ENV PHP_INI_DIR /usr/local/etc/php
RUN set -eux; \
    mkdir -p "$PHP_INI_DIR/conf.d"; \
# allow running as an arbitrary user
# (https://github.com/docker-library/php/issues/743)
    [ ! -d /var/www/html ]; \
    mkdir -p /var/www/html; \
    chown www-data:www-data /var/www/html; \
    chmod 777 /var/www/html

# Apply stack smash protection to functions using local buffers and alloca()
#   Make PHP's main executable position-independent (improves ASLR security
#   mechanism, and has no performance impact on x86_64)
#     Enable optimization (-O2)
#     Enable linker optimization (this sorts the hash buckets to improve cache
#            locality, and is non-default)
#     Adds GNU HASH segments to generated executables (this is used if present,
#          and is much faster than sysv hash; in this configuration, sysv hash
#          is also generated)
#   https://github.com/docker-library/php/issues/272
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ENV PHP_VERSION 8.0.0
ENV PHP_URL="https://github.com/php/php-src/archive/master.zip"

RUN set -xe; \
    \
    apk add --no-cache --virtual .fetch-deps \
        gnupg \
        wget \
    ; \
    \
    mkdir -p /usr/src; \
    cd /usr/src; \
    \
    wget -O php.zip "$PHP_URL"; \
    \
    apk del --no-network .fetch-deps

COPY scripts/docker-php-source /usr/local/bin/

RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
# This will install:
#   libbz2, libpng, freetype, libjpeg-turbo, libwebp, libgd, gd, perl, pkgconf,
#   gd-dev
        gd-dev \
        \
        argon2-dev \
        bison \
        coreutils \
        curl-dev \
        freetype-dev \
        jpeg-dev \
        libedit-dev \
        libffi \
        libffi-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libressl \
        libressl-dev \
        libsodium-dev \
        libxml2-dev \
        oniguruma-dev \
        sqlite-dev \
    \
    && export \
        CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS" \
    && docker-php-source extract \
    && cd /usr/src/php/php-src-master \
    && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && ./buildconf \
    && ./configure --help \
    && ./configure \
        --build="$gnuArch" \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        \
# https://github.com/docker-library/php/issues/439
        --with-mhash \
# https://wiki.php.net/rfc/argon2_password_hash (7.2+)
        --with-password-argon2 \
# https://wiki.php.net/rfc/libsodium
        --with-sodium=shared \
# https://stackoverflow.com/a/43949863/8367711
        --with-openssl=/usr \
        --with-system-ciphers \
# https://wiki.php.net/rfc/ffi
        --with-ffi \
# GD https://codeday.me/jp/qa/20190724/1288444.html
        --enable-gd \
        --with-external-gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
        \
        --with-curl \
        --with-libedit \
        --with-zlib \
        \
# make sure invalid --configure-flags are fatal errors instead of just warnings
        --enable-option-checking=fatal \
# --enable-ftp is included here because ftp_ssl_connect() needs ftp to be
# compiled statically (see https://github.com/docker-library/php/issues/236)
        --enable-ftp \
# --enable-mysqlnd is included here because it's harder to compile after the
# fact than extensions are
# (since it's a plugin for several extensions, not an extension in itself)
        --enable-mysqlnd \
# https://www.php.net/manual/ja/mbstring.installation.php
        --enable-mbstring \
        \
        --enable-soap \
        --enable-pcntl \
        --enable-opcache \
        \
# bundled pcre does not support JIT on s390x
# https://manpages.debian.org/stretch/libpcre3-dev/pcrejit.3.en.html#AVAILABILITY_OF_JIT_SUPPORT
        $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
        \
        $PHP_EXTRA_CONFIGURE_ARGS \
    && make -j "$(nproc)" \
    && find -type f -name '*.a' -delete \
    && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
    && make clean \
    \
# https://github.com/docker-library/php/issues/692 (copy default example
# "php.ini" files somewhere easily discoverable)
    && cp -v php.ini-* "$PHP_INI_DIR/" \
    \
    && cd / \
    && docker-php-source delete \
    \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache $runDeps \
    \
    && apk del --no-network .build-deps \
    \
    && rm -rf /tmp/pear ~/.pearrc

COPY scripts/docker-php-ext-* scripts/docker-php-entrypoint /usr/local/bin/

# sodium was built as a shared module (so that it can be replaced later if so
# desired), so let's enable it too
# (https://github.com/docker-library/php/issues/598)
RUN docker-php-ext-enable sodium

COPY php.ini/docker-php-enable-jit.ini /usr/local/etc/php/conf.d/docker-php-enable-jit.ini
COPY php.ini/docker-php-enable-mb.ini /usr/local/etc/php/conf.d/docker-php-enable-mb.ini

HEALTHCHECK \
  --interval=60m \
  --timeout=10s \
  --start-period=10m \
  --retries=1 CMD [ 'php -r "echo phpversion();"' ]

USER www-data

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]
