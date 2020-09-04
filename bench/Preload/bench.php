<?php
/**
 * Do not cache/preload this script.
 */
if (! function_exists('zundoko')) {
    require_once('functions.php');
    echo '- Requiring functions.php (NO PRELOAD)' . PHP_EOL;
} else {
    echo '* Functions are pre-loaded !!' . PHP_EOL;
}

if (function_exists("date_default_timezone_set")) {
    date_default_timezone_set("UTC");
}

const WIDTH_INDENT=50;

// ============================================================================
//  Functions for benching
// ============================================================================

if (function_exists('hrtime')) {
    function gethrtime()
    {
        $hrtime = hrtime();
        return (($hrtime[0]*1000000000 + $hrtime[1]) / 1000000000);
    }
} else {
    function gethrtime()
    {
        return microtime(true);
    }
}

function start_test()
{
    ob_start();
    return gethrtime();
}

function end_test($start, $name)
{
    global $total;

    $end = gethrtime();
    ob_end_clean();
    $total += $end-$start;
    $num = number_format($end-$start, 3);
    $pad = str_repeat(" ", WIDTH_INDENT - strlen($name) - strlen($num));

    echo $name.$pad.$num."\n";
    ob_start();

    return gethrtime();
}

function total()
{
    global $total;

    $pad = str_repeat("-", WIDTH_INDENT);
    echo $pad . "\n";
    $num = number_format($total, 3);
    $pad = str_repeat(" ", WIDTH_INDENT - strlen("Total") - strlen($num));
    echo "Total" . $pad.$num . "\n";
}

// ============================================================================
//  Bench
// ============================================================================
echo 'PHP Version:', phpversion(), PHP_EOL;

/**
 * Fibonacci 32
 */
$t0 = $t = start_test();
$fibonacci = fibonacci(32);
$t = end_test($t, "Fibonacci 32");

/**
 * Zundoko-Kiyoshi Looping
 */
$zundoko = zundoko(500000);
$t = end_test($t, "Zundoko Kiyoshi Loop");

total();
