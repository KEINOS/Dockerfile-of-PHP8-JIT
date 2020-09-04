<?php
/**
 * Functions that will be preloaded.
 */

function fibonacci($n)
{
    return(($n < 2) ? 1 : fibonacci($n - 2) + fibonacci($n - 1));
}

function zundoko($n)
{
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
                if ($z >= 4) {
                    break;
                }
                $z = 0;
            }
        } while (true);
    }

    return $length / $total + 3;
}
