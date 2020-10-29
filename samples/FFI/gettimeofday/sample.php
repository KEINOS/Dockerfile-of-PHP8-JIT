<?php

// create gettimeofday() binding
$ffi = FFI::cdef("
    typedef unsigned int time_t;
    typedef unsigned int suseconds_t;

    struct timeval {
        time_t      tv_sec;
        suseconds_t tv_usec;
    };

    struct timezone {
        int tz_minuteswest;
        int tz_dsttime;
    };

    int gettimeofday(struct timeval *tv, struct timezone *tz);
", "libc.so.6");

// create C data structures
$tv = $ffi->new("struct timeval");
$tz = $ffi->new("struct timezone");

// call C's gettimeofday()
var_dump($ffi->gettimeofday(FFI::addr($tv), FFI::addr($tz)));

// access field of C data structure
var_dump($tv->tv_sec);

// print the whole C data structure
var_dump($tz);
