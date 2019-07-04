<?php
# Run a nice and simple Fibonacci function.
# See: https://arkadiuszkondas.com/how-to-run-php-8-with-jit-support-using-docker/

echo 'PHP Version:', phpversion(), PHP_EOL;

function fibonacci($n){
    return(($n < 2) ? 1 : fibonacci($n - 2) + fibonacci($n - 1));
}

$n = 32;
$start     = microtime(true);
$fibonacci = fibonacci($n);
$stop      = microtime(true);

echo sprintf("Fibonacci(%s): %s\nTime: %s", $n, $fibonacci, $stop-$start), PHP_EOL, PHP_EOL;
