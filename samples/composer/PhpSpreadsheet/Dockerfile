
FROM keinos/php8-jit

USER root

WORKDIR /app

# Install composer
RUN \
    echo '- Installing composer ...' && \
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"; \
    [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ] && { >&2 echo 'ERROR: Invalid installer signature'; exit 1; }; \
    php composer-setup.php --quiet --install-dir=/bin --version=1.10.17 --filename=composer && \
    composer --version && \
    rm composer-setup.php && \
    apk add --no-cache \
        # Composer requires git to download the packages
        git

# Install PHP extensions which PhpSpreadsheet and it samples require
RUN \
    # Install dependencies of the extension. For the extensions
    # installed/loaded see ../../info-get_loaded_extensions.txt
    apk add --no-cache \
        # PHP Zip extension requires libzip
        libzip-dev && \
    docker-php-ext-install \
        # ext-zip
        zip && \
    # Install PhpSpreadsheet with samples
    composer require --prefer-source phpoffice/phpspreadsheet

RUN \
    # Requirements for samples
    composer require \
        phenx/php-font-lib \
        phenx/php-svg-lib \
        dompdf/dompdf \
        mpdf/mpdf \
        tecnickcom/tcpdf \
        jpgraph/jpgraph \
        mpdf/mpdf

RUN \
    # Smoke test
    php ./vendor/phpoffice/phpspreadsheet/samples/index.php

ENTRYPOINT php -S 0.0.0.0:8080 -t /app/vendor/phpoffice/phpspreadsheet/samples
