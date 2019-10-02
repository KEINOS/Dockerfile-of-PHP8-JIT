[![](https://images.microbadger.com/badges/image/keinos/php8-jit.svg)](https://microbadger.com/images/keinos/php8-jit "See Image Info on microbadger.com")
[![](https://img.shields.io/docker/cloud/automated/keinos/php8-jit.svg)](https://hub.docker.com/r/keinos/php8-jit "Docker Cloud Automated build")
[![](https://img.shields.io/docker/cloud/build/keinos/php8-jit.svg)](https://hub.docker.com/r/keinos/php8-jit/builds "Docker Cloud Build Status")

# PHP8.0 with JIT Enabled on Docker

- x86_64/ARMv7/ARMv6 architecture available.

    ```bash
    # x86_64(Intel/AMD) and ARMv7 CPU Architecture (For most users)
    docker pull keinos/php8-jit:latest
    ```
    ```bash
    # ARMv6 CPU Architecture (For RaspberryPi Zero Users)
    docker pull keinos/php8-jit:arm32v6
    ```
  - [Available Tags](https://cloud.docker.com/repository/docker/keinos/php8-jit/tags)

- This image is based on:
  - Document: [How to run PHP 8 with JIT support using Docker](https://arkadiuszkondas.com/how-to-run-php-8-with-jit-support-using-docker/) @ arkadiuszkondas.com

- Image Info
  - Base Image: Alpine Linux v3.8 (keinos/alpine)
  - Image Repo: https://hub.docker.com/r/keinos/php8-jit @ Docker Hub
  - Source Repo: https://github.com/KEINOS/Dockerfile-of-PHP8-JIT @ GitHub

- Settings to be noted:
  - Default user: `www-data`
  - JIT/OPcache/Sodium: enabled
  - `mbstring`: enabled
    - multibyte = On
    - Encoding = UTF-8 (Both script and internal)
    - language = Japanese
  - GD: enabled
  - [phpinfo()]('phpinfo.txt')
  - Loaded Extensions]('info-get_loaded_extensions.txt')

## Usage

```shellsession
$ # Pull image (If ARMv6 architecture then specify tag as keinos/php8-jit:arm32v6)
$ docker pull keinos/php8-jit:latest
...
```

```shellsession
$ # Run interactively
$ docker run --rm -it keinos/php8-jit:latest
Interactive shell

php > echo phpversion();
8.0.0-dev
php > exit
$
```

```shellsession
$ # Mount local file and run
$ ls
test.php
$ # Run script
$ docker run --rm \
>   -v $(pwd)/test.php:/app/test.php \
>   -w /app \
>   keinos/php8-jit \
>   php test.php
...
```

## Perfomance Comparison

- [Test Code](https://github.com/KEINOS/Dockerfile-of-PHP8-JIT/blob/php8-jit/test/test-fibonacci.php)

- Result

    ```shellsession
    - Run test with PHP7 (Local run on macOS)
    PHP Version:7.1.23
    Fibonacci(32): 3524578
    Time: 0.31194710731506

    - Run test with PHP7 (Docker: php:7.3.6-alpine)
    PHP Version:7.3.6
    Fibonacci(32): 3524578
    Time: 0.23761606216431

    - Run test with PHP8 JIT Disabled (Docker: akondas/php:8.0-cli-alpine)
    PHP Version:8.0.0-dev
    Fibonacci(32): 3524578
    Time: 0.24200105667114

    - Run test with PHP8 JIT Enabled (Docker: keinos/php8-jit:8.0.0-dev)
    PHP Version:8.0.0-dev
    Fibonacci(32): 3524578
    Time: 0.10379791259766
    ```

- Tested Env

    ```shellsession
    $ # macOS Mojave (OSX 10.14.5)
    $ sw_vers
    ProductName:	Mac OS X
    ProductVersion:	10.14.5
    BuildVersion:	18F132

    $ docker version
    Client: Docker Engine - Community
    Version:           18.09.2
    API version:       1.39
    Go version:        go1.10.8
    Git commit:        6247962
    Built:             Sun Feb 10 04:12:39 2019
    OS/Arch:           darwin/amd64
    Experimental:      false

    Server: Docker Engine - Community
    Engine:
    Version:          18.09.2
    API version:      1.39 (minimum version 1.12)
    Go version:       go1.10.6
    Git commit:       6247962
    Built:            Sun Feb 10 04:13:06 2019
    OS/Arch:          linux/amd64
    Experimental:     false
    ```
