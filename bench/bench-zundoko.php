<?php
# Hardcore Zundoko-Kiyoshi Looping
# See: https://qiita.com/mpyw/items/b9be5c81ef9389c0267d

echo 'TEST: Zundoko-Kiyoshi Looping', PHP_EOL;
echo 'PHP Version:', phpversion(), PHP_EOL;

function zundoko($n){
    $length = 0;
    $total  = $n;
    while ($n--) {
        $z = 0;
        do {
            $length += 2;
            // 1073741824 は mt_getrandmax() / 2 の値
            if (mt_rand() < 1073741824) {
                ++$z;
            } else {
                if ($z >= 4) break;
                $z = 0;
            }
        } while (true);
    }

    return $length / $total + 3;
}

$n = 500000;

$start   = microtime(true);
$zundoko = zundoko($n);
$stop    = microtime(true);

echo sprintf("Len Avg: %s\nTime: %s", $zundoko, $stop-$start), PHP_EOL, PHP_EOL;