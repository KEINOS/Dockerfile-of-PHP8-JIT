#!/bin/sh

echo '- Ini file for preload'
ls -l /usr/local/etc/php/conf.d/ | grep preload

echo '- List OPCache (Before run):'
ls -l /tmp/php/opcache

echo '- PHP INFO'
php -i | grep opcache | grep file_cache_only
php -i | grep preload

echo
echo '- First run'
php /app/bench.php
sleep 3

echo
echo '- Second run'
php /app/bench.php
sleep 3

echo
echo '- List OPCache (After run):'
ls -l /tmp/php/opcache
