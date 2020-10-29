# Example of calling a function, returning a structure through an argument

Sample Dockerfile to check [FFI](https://www.php.net/manual/en/intro.ffi.php) functionality.

It binds the `gettimeofday()` Clang function by using "libc.so.6".

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
int(1603947913)
object(FFI\CData:struct timezone)#3 (2) {
  ["tz_minuteswest"]=>
  int(259930)
  ["tz_dsttime"]=>
  int(0)
}
```
