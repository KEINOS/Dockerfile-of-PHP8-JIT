[![](https://img.shields.io/docker/v/keinos/php8-jit)](https://hub.docker.com/r/keinos/php8-jit/tags "Latest build")
[![](https://img.shields.io/docker/image-size/keinos/php8-jit?sort=semver)](https://cloud.docker.com/repository/docker/keinos/php8-jit "Docker Image Size (latest semver)")
[![](https://img.shields.io/docker/pulls/keinos/php8-jit)](https://hub.docker.com/r/keinos/php8-jit "Docker Pulls from Docker Hub")
[![](https://img.shields.io/github/issues/KEINOS/Dockerfile_of_PHP8-JIT)](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/issues "GitHub issues")
[![](https://img.shields.io/badge/GitHub-Dockerfile-blue?logo=github)](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT "View the Dockerfile in GitHub")
[![](https://img.shields.io/badge/dockerhub-Image-blue?logo=docker)](https://hub.docker.com/r/keinos/php8-jit "View image info on DockerHub")

- [![](https://travis-ci.org/KEINOS/Dockerfile_of_PHP8-JIT.svg?branch=php8-jit)](https://travis-ci.org/KEINOS/Dockerfile_of_PHP8-JIT "Test Build on TravisCI") (Run [unit tests](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/tree/php8-jit/tests) with the built Docker image on Travis CI)

# PHP8.0 with JIT Enabled on Docker

This is a PHP8.0.0-dev Alpine Docker image with **JIT feature enabled** built from [official latest master source](https://github.com/php/php-src).

```bash
docker pull keinos/php8-jit:latest
```

- **NOTE: On ARM architectures `JIT` won't turn ON, [yet](https://aws.amazon.com/jp/blogs/compute/improving-performance-of-php-for-arm64-and-impact-on-amazon-ec2-m6g-instances/).** Though, it's still fast.
- The `latest` tag image **works on: ARM v6l, ARM v7l, ARM64 and x86_64 (AMD/Intel) architectures**.

<details><summary>Image Informations and notes</summary><div><br>

- Based on/inspired by:
  - Document: [How to run PHP 8 with JIT support using Docker](https://arkadiuszkondas.com/how-to-run-php-8-with-jit-support-using-docker/) @ arkadiuszkondas.com
- PHPINFO: [info-phpinfo.txt](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/blob/php8-jit/info-phpinfo.txt)
- Modules/Extensions: [info-get_loaded_extensions.txt](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/blob/php8-jit/info-get_loaded_extensions.txt)
- Source: Built from the latest `master` branch from [PHP-src](https://github.com/php/php-src) @ GitHub
- Tags available: [see](https://cloud.docker.com/repository/docker/keinos/php8-jit/tags) @ DockerHub
- Image Info
  - Build Frequency: Mostly every update of Alpine Docker image or PHP releases.
  - Base Image: Alpine Linux from [keinos/alpine:latest](https://hub.docker.com/repository/docker/keinos/alpine)
  - Source Repo(Dockerfile): https://github.com/KEINOS/Dockerfile-of-PHP8-JIT @ GitHub
  - Image Repo: https://hub.docker.com/r/keinos/php8-jit @ Docker Hub
- Path Info
  - Configuration Files: `usr/local/etc/php/conf.d/` (php.ini)
  - Extension Files: `/usr/local/lib/php/extensions/`
  - PHP Source Archive: `/usr/src/php.7z`
  - PHP Source Path (After extraction): `/usr/src/php/php-src-master/`
- Extract/Delete Archived PHP Source
  - Extract archive: `docker-php-source extract`
  - Delete extracted source: `docker-php-source delete`
  - Delete extracted source and cache: `docker-php-source prune`.
- Settings to be noted:
  - Default user: `www-data`
  - Constant `GLOB_BRACE` flag for `glob` is not available.
    - See: [Notes](https://www.php.net/manual/en/function.glob.php) | glob @ PHP manual
  - Modules/Extensions:
    - **JIT**/**FFI**/OPcache/Sodium/PECL: enabled
  - `mbstring`: enabled
    - multibyte = On
    - Encoding = UTF-8 (Both script and internal)
    - language = Japanese
  - GD: enabled
  - [etc.](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/blob/php8-jit/info-get_loaded_extensions.txt)

---

</div></details>

## Usage

```shellsession
$ # Pull latest image
$ docker pull keinos/php8-jit
...
```

```shellsession
$ # Run interactively
$ docker run --rm -it keinos/php8-jit
Interactive shell

php > echo phpversion();
8.0.0-dev
php >
php > exit
$
```

```shellsession
$ # Mount local file and run/execute the script
$ ls
test.php

$ # Run script
$ docker run --rm \
>   -v $(pwd)/test.php:/app/test.php \
>   keinos/php8-jit \
>   php /app/test.php
Hello, World!
$
```

```shellsession
$ # Mount files and run interactively inside the container
$ docker run --rm -it -v $(pwd):/app keinos/php8-jit /bin/sh
/ $ php -v
PHP 8.0.0-dev (cli) (built: Jun 27 2020 22:23:17) ( NTS )
Copyright (c) The PHP Group
Zend Engine v4.0.0-dev, Copyright (c) Zend Technologies
    with Zend OPcache v8.0.0-dev, Copyright (c), by Zend Technologies
/ $ cd /app
/app $
/app $ ls
test.php
/app $ php test.php
Hello, World!
/app $
/app $ exit
$
```

```dockerfile
# Sample Dockerfile to install composer
FROM keinos/php8-jit:latest

USER root

COPY . /app

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

# Install PHPUnit
RUN \
    composer require --ignore-platform-reqs phpunit/phpunit && \
    ./vendor/bin/phpunit --version

ENTRYPOINT [ "/app/vendor/bin/phpunit", "--testdox", "./tests" ]

```

## Samples

- Sample Dockerfiles: [./samples/](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/tree/php8-jit/samples)

## FAQ/Troubleshooting/TIPS

- See: [FAQ.md](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/blob/php8-jit/FAQ.md)

## Advanced Usage

### Installing Extensions

To instal [PHP extensions](https://github.com/php/php-src/tree/master/ext) use `docker-php-ext-install` command. (This will enable the extension as well.)

- Available extensions to install
  - [php-src/tree/master/ext](https://github.com/php/php-src/tree/master/ext) | PHP @ GitHub

- Dockerfile sample to install `gettext` extension.

  ```Dockerfile
  FROM keinos/php8-jit:latest

  # You need a root access to install
  USER root

  RUN \
      # Install dependencies for gettext
      apk --no-cache add gettext-dev && \
      # Install gettext extension
      docker-php-ext-install gettext && \
      # Delete PHP source archive cache
      docker-php-source prune

  # Switch back to default user
  USER www-data

  ```

### Installing PECL Packages

The [PECL](https://pecl.php.net/) command is included. (Since [build-20200825](https://hub.docker.com/r/keinos/php8-jit/tags), Issue [#13](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/issues/13))

But as an alternative, you can use `docker-php-ext-pecl install` to install PECL packages from source.

- Sample of installing [YAML Functions](https://www.php.net/manual/en/ref.yaml.php) of PECL from source.

  ```Dockerfile
  FROM keinos/php8-jit:latest

  # You need a root access to compile and install packages
  USER root

  RUN \
      # Install dependencies for YAML
      apk --no-cache add yaml-dev && \
      # Install PECL from source
      docker-php-ext-pecl install yaml && \
      # Delete PHP source archive cache
      docker-php-source prune

  # Switch back to default user
  USER www-data
  ```

- **Note:** Some PECL extension packages are not available to install. Extensions such as '`json`', '`hash`' and etc.
- For more see [samples](./samples/).

## Perfomance Comparison

- [Test Codes](https://github.com/KEINOS/Dockerfile-of-PHP8-JIT/blob/php8-jit/test/)

Test                    | v5.6.40 | v7.0.33 | v7.1.33 | v7.2.31 | v7.3.18 | v7.4.6 | 8.0.0-dev<br>(JIT Off) | 8.0.0-dev<br>(JIT On)
:---------------------- | :-----: | :-----: | :-----: | :-----: | :-----: | :----: | :---: | :--: |
[Fibonacci(32)](https://github.com/KEINOS/Dockerfile-of-PHP8-JIT/blob/php8-jit/test/test-fibonacci.php)         | 1.521   | 0.665   | 0.598   | 0.269   | 0.239   | 0.194  | 0.261 | 0.107
[Zundoko-Kiyoshi Looping](https://github.com/KEINOS/Dockerfile-of-PHP8-JIT/blob/php8-jit/test/test-zundoko.php) | 2.485   | 1.462   | 1.413   | 0.701   | 0.646   | 0.636  | 0.672 | 0.416
-- [Zend Bench](https://github.com/KEINOS/Dockerfile-of-PHP8-JIT/blob/php8-jit/test/test-zend_bench.php) --     |         |         |         |         |         |        |       |
simple                  | 0.178   | 0.100   | 0.101   | 0.064   | 0.051   | 0.041  | 0.054 | 0.002
simplecall              | 0.186   | 0.027   | 0.027   | 0.010   | 0.010   | 0.007  | 0.010 | 0.001
simpleucall             | 0.210   | 0.071   | 0.080   | 0.023   | 0.018   | 0.025  | 0.022 | 0.001
simpleudcall            | 0.226   | 0.076   | 0.088   | 0.028   | 0.021   | 0.021  | 0.024 | 0.001
mandel                  | 0.491   | 0.320   | 0.329   | 0.189   | 0.190   | 0.175  | 0.189 | 0.007
mandel2                 | 0.643   | 0.360   | 0.358   | 0.167   | 0.167   | 0.184  | 0.170 | 0.008
ackermann(7)            | 0.187   | 0.061   | 0.067   | 0.032   | 0.031   | 0.031  | 0.033 | 0.015
ary(50000)              | 0.031   | 0.008   | 0.007   | 0.007   | 0.008   | 0.007  | 0.007 | 0.007
ary2(50000)             | 0.025   | 0.006   | 0.005   | 0.006   | 0.007   | 0.006  | 0.006 | 0.006
ary3(2000)              | 0.298   | 0.142   | 0.124   | 0.059   | 0.047   | 0.044  | 0.049 | 0.015
fibo(30)                | 0.594   | 0.230   | 0.228   | 0.106   | 0.091   | 0.081  | 0.093 | 0.042
hash1(50000)            | 0.049   | 0.024   | 0.024   | 0.016   | 0.015   | 0.015  | 0.015 | 0.016
hash2(500)              | 0.053   | 0.022   | 0.023   | 0.013   | 0.008   | 0.008  | 0.008 | 0.011
heapsort(20000)         | 0.145   | 0.073   | 0.069   | 0.037   | 0.036   | 0.036  | 0.037 | 0.014
matrix(20)              | 0.130   | 0.067   | 0.062   | 0.034   | 0.035   | 0.030  | 0.030 | 0.014
nestedloop(12)          | 0.301   | 0.145   | 0.143   | 0.088   | 0.091   | 0.072  | 0.091 | 0.013
sieve(30)               | 0.151   | 0.041   | 0.053   | 0.021   | 0.018   | 0.014  | 0.017 | 0.005
strcat(200000)          | 0.027   | 0.014   | 0.015   | 0.011   | 0.011   | 0.011  | 0.010 | 0.010
---------------         | ------- | ------- | ------- | ------- | ------- | ------ | ----- | -----
Total                   | 3.923   | 1.787   | 1.804   | 0.911   | 0.855   | 0.805  | 0.867 | 0.187

- Tested Env

    ```shellsession
    $ # macOS Mojave (OSX 10.14.5)
    $ sw_vers
    ProductName:	Mac OS X
    ProductVersion:	10.14.6
    BuildVersion:	18G4032

    $ # Docker 19.03.8
    $ docker version
    Client: Docker Engine - Community
    Version:           19.03.8
    API version:       1.40
    Go version:        go1.12.17
    Git commit:        afacb8b
    Built:             Wed Mar 11 01:21:11 2020
    OS/Arch:           darwin/amd64
    Experimental:      true

    Server: Docker Engine - Community
    Engine:
      Version:          19.03.8
      API version:      1.40 (minimum version 1.12)
      Go version:       go1.12.17
      Git commit:       afacb8b
      Built:            Wed Mar 11 01:29:16 2020
      OS/Arch:          linux/amd64
      Experimental:     true
    containerd:
      Version:          v1.2.13
      GitCommit:        7ad184331fa3e55e52b890ea95e65ba581ae3429
    runc:
      Version:          1.0.0-rc10
      GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
    docker-init:
      Version:          0.18.0
      GitCommit:        fec3683

    ```
