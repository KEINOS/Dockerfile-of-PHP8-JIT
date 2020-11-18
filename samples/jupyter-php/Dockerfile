# Sample Dockerfile of PHP8+JIT for Jupyter-PHP
#
# This Dockerfile installs:
#   - PHP Kernel for Jupyter(Jupyter-PHP)
#   - Python3, pip
#   - Jupyter. Such as Jupyter Lab, notebook, etc.
#
# References that we used to create this Dockerfile.
#   - https://jupyterlab.readthedocs.io/en/stable/getting_started/installation.html | Jupyter lab @ readthedocs.io
#   - https://qiita.com/yes_dog/items/0751555e8f6c7f614d14 @ Qiita
#   - https://qiita.com/tand826/items/0c478bf63ead75427782 @ Qiita
#   - https://github.com/Litipk/Jupyter-PHP @ GitHub
#   - https://github.com/nbgallery/jupyter-alpine @ GitHub
#   - https://github.com/nbgallery/jupyter-alpine @ GitHub

FROM keinos/php8-jit:latest

# To install extensions and packages you need root access
USER root

# The Jupyter lab server will listen to the following port. Don't forget to
# pushish the port to access from local to the container.
#    ex) docker run -p 8080:8000 jupyter:local
EXPOSE 8000

# When the container is up with no arguments, Jupyter lab's web server will
# launch.
CMD /usr/local/bin/jupyter lab --port 8000 --ip=0.0.0.0 --allow-root --no-browser

# =============================================================================
#  Copy patches
# =============================================================================
# Alternate composer file to install Jupyter-PHP
COPY diff.jupyter-php.patch /diff.jupyter-php.patch
# Patch Jupyter PHP Kernel version from "PHP" to "PHP 8.0"
COPY diff.kernel.patch /diff.kernel.patch

# =============================================================================
#  Install Jupyter-PHP
# =============================================================================
RUN apk --no-cache add \
        # jupyter-php requires 0MQ(ZMQ, ZeroMQ), which is a software library that
        # lets you quickly design and implement a fast message-based application.
        zeromq-dev \
        # Install deps
        git \
        patch \
        ca-certificates \
    && \
    # Insall ZeroMQ PECL extension.
    # But the package in https://pecl.php.net/package/zmq fails to build. So
    # download and installs from the source.
    docker-php-source extract && \
    git clone https://github.com/mkoppanen/php-zmq.git/ /usr/src/php/php-src-master/ext/zmq && \
    docker-php-ext-install zmq && \
    \
    # Install Composer
    echo '- Installing composer ...' && \
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"; \
    [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ] && { >&2 echo 'ERROR: Invalid installer signature'; exit 1; }; \
    php composer-setup.php --install-dir=/bin --version=1.10.17 --filename=composer && \
    # Smoke test (composer)
    composer --version && \
    rm composer-setup.php && \
    \
    # Begin install Jupyter PHP
    cd "$HOME" && \
    name_repo="Jupyter-PHP-Installer" && \
    # Download Jupyter-PHP installer.
    #   We need to patch some files in order to install Jupyter PHP on PHP8.
    #   So use the src of the installer from the official site.
    git clone "https://github.com/Litipk/${name_repo}.git" "$name_repo" && \
    cd "${HOME}/${name_repo}" && \
    # Patch the diffs
    patch -p1 < /diff.jupyter-php.patch && \
    # Prepare install
    composer install \
        --no-dev \
        --no-interaction \
        --ignore-platform-reqs \
        --optimize-autoloader \
        --verbose \
    && \
    # Install Jupyter-PHP kernel
    php ./src/EntryPoint/main.php install --verbose

# =============================================================================
#  Install Python3
# =============================================================================

ENV \
    # http://bugs.python.org/issue19846
    # > At the moment, setting "LANG=C" on a Linux system
    # *fundamentally breaks Python 3*, and that's not OK.
    LANG=C.UTF-8 \
    \
    GPG_KEY=E3FF2839C048B25C084DEBE9B26995E310250568 \
    PYTHON_VERSION=3.9.0 \
    # if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
    PYTHON_PIP_VERSION=20.2.4 \
    # https://github.com/pypa/get-pip
    PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/8283828b8fd6f1783daf55a765384e6d8d2c5014/get-pip.py \
    PYTHON_GET_PIP_SHA256=2250ab0a7e70f6fd22b955493f7f5cf1ea53e70b584a84a32573644a045b4bfb

RUN set -ex && \
    apk add --no-cache \
        # install ca-certificates so that HTTPS works consistently
        # other runtime dependencies for Python are installed later
        ca-certificates \
        && \
	apk add --no-cache --virtual .fetch-python-deps \
		gnupg \
		tar \
		xz \
	    && \
	wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" && \
	wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" && \
	export GNUPGHOME="$(mktemp -d)" && \
	gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" && \
	gpg --batch --verify python.tar.xz.asc python.tar.xz && \
	{ command -v gpgconf > /dev/null && gpgconf --kill all || :; } && \
	rm -rf "$GNUPGHOME" python.tar.xz.asc && \
	mkdir -p /usr/src/python && \
	tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz && \
	rm python.tar.xz && \
	\
	apk add --no-cache --virtual .build-python-deps \
		bluez-dev \
		bzip2-dev \
		coreutils \
		dpkg-dev dpkg \
		expat-dev \
		findutils \
		gcc \
		gdbm-dev \
		libc-dev \
		libffi-dev \
		libnsl-dev \
		libtirpc-dev \
		linux-headers \
		make \
		ncurses-dev \
		openssl-dev \
		pax-utils \
		readline-dev \
		sqlite-dev \
		tcl-dev \
		tk \
		tk-dev \
		util-linux-dev \
		xz-dev \
		zlib-dev \
        && \
    # add build deps before removing fetch deps in case there's overlap
	apk del --no-network .fetch-python-deps && \
	\
	cd /usr/src/python && \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
	./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip \
        && \
	make -j "$(nproc)" \
    # set thread stack size to 1MB so we don't segfault before we hit sys.getrecursionlimit()
    # https://github.com/alpinelinux/aports/commit/2026e1259422d4e0cf92391ca2d3844356c649d0
		EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000" \
		LDFLAGS="-Wl,--strip-all" \
        && \
	make install && \
	rm -rf /usr/src/python && \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) \) \
		\) -exec rm -rf '{}' + \
	    && \
	find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' \
		| tr ',' '\n' \
		| sort -u \
		| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
		| xargs -rt apk add --no-cache --virtual .python-rundeps \
        && \
	apk del --no-network .build-python-deps && \
	\
    # Smoke test
	python3 --version

# make some useful symlinks that are expected to exist
RUN \
    cd /usr/local/bin && \
	ln -s idle3 idle && \
	ln -s pydoc3 pydoc && \
	ln -s python3 python && \
	ln -s python3-config python-config

# Install pip
RUN set -ex; \
	\
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	echo "${PYTHON_GET_PIP_SHA256} *get-pip.py" | sha256sum -c -; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==$PYTHON_PIP_VERSION" \
	; \
	pip --version; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' +; \
	rm -f get-pip.py

# =============================================================================
#  Install Jupyter
# =============================================================================
RUN \
    # Patch Jupyter-PHP kernel version from "PHP" to "PHP 8.0"
    path_dir_kernel=$(find / -name jupyter-php | grep kernels) && \
    ls "${path_dir_kernel}/kernel.json" && \
    cd "${path_dir_kernel}" && \
    patch kernel.json < /diff.kernel.patch && \
    # Install requirements
    apk add --no-cache \
        gcc \
        libffi-dev \
        musl-dev \
        nodejs \
        && \
    # Install Jupyter via pip
    pip install \
        jupyter \
        jupyterlab \
        && \
    # Smoke test
    jupyter --version && \
    # Check Jupyter-PHP kernel
    jupyter kernelspec list | grep jupyter-php && \
    # Create workspace
    mkdir /workspace

WORKDIR /workspace
