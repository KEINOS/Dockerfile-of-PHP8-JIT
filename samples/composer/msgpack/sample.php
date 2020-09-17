<?php
/**
 * For usage of `rybakit/msgpack` see: https://github.com/rybakit/msgpack.php
 */
require(__DIR__ . "/vendor/autoload.php");

use MessagePack\Packer;
use MessagePack\BufferUnpacker;

$packer   = new Packer();
$unpacker = new BufferUnpacker();

echo '- Raw data' . PHP_EOL;
$data = array(0=>1,1=>2,2=>3);
print_r($data);

echo '- Packed data' . PHP_EOL;
$packed = $packer->pack($data);
var_dump($packed);

echo '- Unpacked data' . PHP_EOL;
$unpacker->reset($packed);
$data = $unpacker->unpack();
print_r($data);
