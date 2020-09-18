ARG NAME_IMAGE_BASE='keinos/alpine'
ARG NAME_IMAGE_TAG='latest'

# =============================================================================
FROM ${NAME_IMAGE_BASE}:${NAME_IMAGE_TAG}

# These values are the default and must be replaced with the build option flag
# such as: --build-arg <varname>=<value>
ARG ID_BUILD='build-20200917'
ARG VERSION_PHP='8.0.0-dev'
ARG TAG_RELESED='8.0.0-dev-build-20200917'
ARG VERSION_OS

LABEL \
        MAINTAINER='https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/' \
        PHP_VERSION="$VERSION_PHP" \
        ID_BUILD="$ID_BUILD" \
        ALPINE="$VERSION_OS"

ENV \
        ID_BUILD="$ID_BUILD" \
        TAG_RELESED="$TAG_RELESED" \
        VERSION_PHP="$VERSION_PHP" \
        PHP_VERSION="$VERSION_PHP" \
        PHP_INI_DIR='/usr/local/etc/php' \
        PHP_URL_ORIGINAL="https://github.com/php/php-src/archive/master.zip" \
        PHP_URL="https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/releases/download/${TAG_RELESED}/php.7z" \
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
        PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
        PHP_CPPFLAGS="$PHP_CFLAGS" \
        PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie" \
        # This container will NOT include the archived PHP source in the image.
        # It will download from the below URLs when the "docker-php-source extract" command was called.
        # Note that the archived files must be released ahead with the given release tag of GitHub.
        URL_SRC_ARCHIVE="https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/releases/download/${TAG_RELESED}/php.7z" \
        URL_SRC_ARCHIVE_SIGNATURE="https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/releases/download/${TAG_RELESED}/php.7z.sig" \
        URL_PUBKEY_SIGNATURE="https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/releases/download/${TAG_RELESED}/id_rsa.pkcs8.pub"

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
        re2c \
        tar

COPY scripts/docker-php-* /usr/local/bin/
COPY php.ini/docker-php-enable-* /usr/local/etc/php/conf.d/
COPY id_rsa.pkcs8.pub /id_rsa.pkcs8.pub

RUN set -eux; \
        # persistent/runtime deps
        apk add --no-cache \
        ca-certificates \
        curl \
        # https://github.com/docker-library/php/issues/494
        libressl \
        # ensure www-data user exists
        # 82 is the standard uid/gid for "www-data" in Alpine
        # https://git.alpinelinux.org/aports/tree/main/apache2/apache2.pre-install?h=3.9-stable
        # https://git.alpinelinux.org/aports/tree/main/lighttpd/lighttpd.pre-install?h=3.9-stable
        # https://git.alpinelinux.org/aports/tree/main/nginx/nginx.pre-install?h=3.9-stable
        && addgroup -g 82 -S www-data \
        && adduser -u 82 -D -S -G www-data www-data; \
        # allow running as an arbitrary user
        # (https://github.com/docker-library/php/issues/743)
        [ ! -d /var/www/html ] && { mkdir -p /var/www/html; } \
        && chown www-data:www-data /var/www/html \
        && chmod 777 /var/www/html; \
        \
        [ ! -d "${PHP_INI_DIR}/conf.d" ] && { mkdir -p "${PHP_INI_DIR}/conf.d"; }; \
        \
        # temporary install the dependencies to build PHP
        apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        # gd-dev will install the below as well:
        #   gd-dev, libbz2, libpng, freetype, libjpeg-turbo, libwebp, libgd, gd, perl, pkgconf,
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
        \
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
        # make sure invalid --configure-flags are fatal errors instead of just warnings
        --enable-option-checking=fatal \
        \
        # https://github.com/docker-library/php/issues/439
        --with-mhash \
        # --enable-ftp is included here because ftp_ssl_connect() needs ftp to be
        # compiled statically (see https://github.com/docker-library/php/issues/236)
        --enable-ftp \
        # --enable-mbstring is included here because otherwise there's no way to get pecl
        # to use it properly (see https://github.com/docker-library/php/issues/195)
        --enable-mbstring \
        # --enable-mysqlnd is included here because it's harder to compile after the fact
        # than extensions are
        # (since it's a plugin for several extensions, not an extension in itself)
        --enable-mysqlnd \
        # https://wiki.php.net/rfc/argon2_password_hash (7.2+)
        --with-password-argon2 \
        # https://wiki.php.net/rfc/libsodium
        --with-sodium=shared \
        # always build against system sqlite3
        # (https://github.com/php/php-src/commit/6083a387a81dbbd66d6316a3a12a63f06d5f7109)
        --with-pdo-sqlite=/usr \
        --with-sqlite3=/usr \
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
        # in PHP 7.4+, the pecl/pear installers are officially deprecated (requiring an
        # explicit "--with-pear") and will be removed in PHP 8+;
        # see also https://github.com/docker-library/php/issues/846#issuecomment-505638494
        --with-pear \
        \
        --enable-soap \
        --enable-pcntl \
        --enable-opcache \
        --enable-sockets \
        \
        # bundled pcre does not support JIT on s390x
        # https://manpages.debian.org/stretch/libpcre3-dev/pcrejit.3.en.html#AVAILABILITY_OF_JIT_SUPPORT
        $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
        \
        ${PHP_EXTRA_CONFIGURE_ARGS:-} \
        \
        && make -j "$(nproc)" \
        && find -type f -name '*.a' -delete \
        && make install \
        && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
        && make clean \
        \
        # copy default example "php.ini" files somewhere easily discoverable)
        # https://github.com/docker-library/php/issues/692
        && cp -v php.ini-* "${PHP_INI_DIR}/" \
        \
        # sodium was built as a shared module (so that it can be replaced later if so
        # desired), so let's enable it too
        # (https://github.com/docker-library/php/issues/598)
        && docker-php-ext-enable sodium \
        && cd / \
        \
        && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        )" \
        && apk add --no-cache $runDeps \
        \
        && apk del --purge --no-network .build-deps \
        \
        # update pecl channel definitions https://github.com/docker-library/php/issues/443
        && pecl update-channels \
        && rm -rf /tmp/pear ~/.pearrc \
        \
        # Clean up all the source archive
        && docker-php-source prune \
        \
        # smoke test
        && php --version \
        && pecl help version

HEALTHCHECK \
        --interval=60m \
        --timeout=10s \
        --start-period=10m \
        --retries=1 CMD [ 'php -r "echo phpversion();"' ]

USER www-data

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]
