# RFC: Preloading

- Details about RFC Preloading: https://wiki.php.net/rfc/preload

---

```bash
==================================
 Running tests (Preload Enabled)
==================================
- Ini file for preload
-rw-r--r--    1 root     root           291 Aug 29 20:21 docker-php-enable-preload.ini
- List OPCache (Before run):
total 0
- PHP INFO
opcache.file_cache_only => Off => Off
/usr/local/etc/php/conf.d/docker-php-enable-preload.ini,
ffi.enable => preload => preload
ffi.preload => no value => no value
opcache.preload => /app/preloader.php => /app/preloader.php
opcache.preload_user => root => root

- First run
* Functions are pre-loaded !!
PHP Version:8.0.0-dev
Fibonacci 32                                 0.159
Zundoko Kiyoshi Loop                         0.482
--------------------------------------------------
Total                                        0.642

- Second run
* Functions are pre-loaded !!
PHP Version:8.0.0-dev
Fibonacci 32                                 0.155
Zundoko Kiyoshi Loop                         0.565
--------------------------------------------------
Total                                        0.720

- List OPCache (After run):
total 0

==================================
 Running tests (Preload Disabled)
==================================
- Ini file for preload
- List OPCache (Before run):
total 0
- PHP INFO
opcache.file_cache_only => Off => Off
ffi.enable => preload => preload
ffi.preload => no value => no value
opcache.preload => no value => no value
opcache.preload_user => no value => no value

- First run
- Requiring functions.php (NO PRELOAD)
PHP Version:8.0.0-dev
Fibonacci 32                                 0.108
Zundoko Kiyoshi Loop                         0.432
--------------------------------------------------
Total                                        0.540

- Second run
- Requiring functions.php (NO PRELOAD)
PHP Version:8.0.0-dev
Fibonacci 32                                 0.104
Zundoko Kiyoshi Loop                         0.433
--------------------------------------------------
Total                                        0.537

- List OPCache (After run):
total 0
```
