[![](https://images.microbadger.com/badges/image/keinos/php8-jit.svg)](https://microbadger.com/images/keinos/php8-jit "See Image Info on microbadger.com")
[![](https://img.shields.io/docker/cloud/automated/keinos/php8-jit.svg)](https://hub.docker.com/r/keinos/php8-jit "Docker Cloud Automated build")
[![](https://img.shields.io/docker/cloud/build/keinos/php8-jit.svg)](https://hub.docker.com/r/keinos/php8-jit/builds "Docker Cloud Build Status")

# PHP8.0 with JIT Enabled on Docker

- x86_64/Intel CPU Architecture: (For most users)

    ```bash
    docker pull keinos/php8-jit:latest
    ```

- ARM CPU Architecture: (RaspberryPi Users)

    ```bash
    docker pull keinos/php8-jit:arm
    ```

- This image is based on:
  - Document: [How to run PHP 8 with JIT support using Docker](https://arkadiuszkondas.com/how-to-run-php-8-with-jit-support-using-docker/) @ arkadiuszkondas.com

- Image Info
  - Base Image: Alpine Linux v3.8
  - Image: https://hub.docker.com/r/keinos/php8-jit @ Docker Hub
  - Source: https://github.com/KEINOS/Dockerfile-of-PHP8-JIT @ GitHub
  - Default user: `www-data`

- Settings to be noted:
  - JIT/OPcache/Sodium: enabled
  - `mbstring`: enabled
    - multibyte = On
    - Encoding = UTF-8 (Both script and internal)
    - language = Japanese

<details><summary>Loaded Extension</summary><div>

Here's the result of `get_loaded_extensions()`.

```shellsession
$ docker run --rm -it keinos/php8-jit php -r "print_r(get_loaded_extensions());"
Array
(
    [0] => Core
    [1] => date
    [2] => libxml
    [3] => pcre
    [4] => sqlite3
    [5] => zlib
    [6] => ctype
    [7] => curl
    [8] => dom
    [9] => fileinfo
    [10] => filter
    [11] => ftp
    [12] => hash
    [13] => iconv
    [14] => json
    [15] => mbstring
    [16] => pcntl
    [17] => SPL
    [18] => PDO
    [19] => pdo_sqlite
    [20] => session
    [21] => posix
    [22] => readline
    [23] => Reflection
    [24] => standard
    [25] => SimpleXML
    [26] => Phar
    [27] => tokenizer
    [28] => xml
    [29] => xmlreader
    [30] => xmlwriter
    [31] => mysqlnd
    [32] => sodium
    [33] => Zend OPcache
)
```

</div></details>

## Usage

```shellsession
$ # Pull image if needed
$ docker pull keinos/php8-jit
...
$ # Run interactively
$ docker run --rm -it keinos/php8-jit
Interactive shell

php > echo phpversion();
8.0.0-dev
php > exit
$
```

```shellsession
$ # Pull image if needed
$ docker pull keinos/php8-jit
...
$ # Mount local file and run
$ ls
test.php
$ # Run script
$ docker run --rm \
>   -v $(pwd)/test.php:/usr/src/app/test.php \
>   -w /usr/src/app \
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
