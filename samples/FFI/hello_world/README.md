# Basic FFI usage

Sample Dockerfile to check [FFI](https://www.php.net/manual/en/intro.ffi.php) functionality by using "libc.so.6" as FFI to just say "Hello world!".

This sample was taken from the official PHP manual.

- [Basic FFI usage](https://www.php.net/manual/en/ffi.examples-basic.php) | Examples | FFI @ PHP.net

## Usage

```shellsession
$ docker build -t test:local .
...
Successfully tagged test:local
```

```shesllsession
$ docker run --rm test:local php /app/sample.php
Hello world!
```
