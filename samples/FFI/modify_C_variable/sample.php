<?php

// create a new C int variable
$x = FFI::new("int");
var_dump($x->cdata);

// simple assignment
$x->cdata = 5;
var_dump($x->cdata);

// compound assignment
$x->cdata += 2;
var_dump($x->cdata);
