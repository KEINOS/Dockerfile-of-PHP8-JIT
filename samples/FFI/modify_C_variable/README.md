# Example Creating and Modifying C variables

Sample Dockerfile to check [FFI](https://www.php.net/manual/en/intro.ffi.php) functionality.

It creates a new FFI object of C int variable then assigns a value.

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
int(0)
int(5)
int(7)
```
