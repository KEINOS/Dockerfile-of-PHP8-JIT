FROM keinos/php8-jit:latest

# You need root privilege to
USER root

COPY ./sample.php /app/sample.php
COPY ./traindata.txt /app/traindata.txt

WORKDIR /app

ENV  LIBSVM_VERSION     "324"
ENV  LIBLINEAR_VERSION  "220"

RUN set -x \
    && apk --no-cache add --virtual .builddeps \
        libgomp \
        libstdc++ \
        ca-certificates \
        build-base \
        git \
        wget \
    # libsvm source
    && wget -q -O - https://github.com/cjlin1/libsvm/archive/v${LIBSVM_VERSION}.tar.gz \
        | tar -xzf - -C / \
    && cd /libsvm-${LIBSVM_VERSION} \
    ## patch to make OpenMP-enabled LIBSVM 3.14
    && git clone https://github.com/niam/libsvm_openmp_patch /libsvm_openmp_patch \
    && patch < /libsvm_openmp_patch/Makefile.diff \
    && patch < /libsvm_openmp_patch/svm_cpp.diff \
    ## make
    && make all lib \
    && cp svm-train svm-predict svm-scale /usr/local/bin/ \
    && cp libsvm.so* /usr/local/lib/ \
    # liblinear source
    && wget -q -O - https://github.com/cjlin1/liblinear/archive/v${LIBLINEAR_VERSION}.tar.gz \
        | tar -xzf - -C / \
    && cd /liblinear-${LIBLINEAR_VERSION} \
    ## make
    && make all lib \
    && cp train predict /usr/local/bin/ \
    && cp liblinear.so* /usr/local/lib/ \
    ## clean
    && apk del .builddeps \
    && rm -rf /liblinear* /libsvm* \
    && which svm-train \
    ## Install SVM extension via PECL from source
    && docker-php-ext-pecl install svm \
    # Create model data dir
    && mkdir /app/models

ENTRYPOINT [ "php", "sample.php" ]