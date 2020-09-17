<?php declare(strict_types=1);

require_once(__DIR__ . '/../vendor/autoload.php');

use PHPUnit\Framework\TestCase;
use MessagePack\Packer;
use MessagePack\BufferUnpacker;

final class MsgpackViaComposerTest extends TestCase
{
    public function testRegularUsage(): void
    {
        $packer   = new Packer();
        $unpacker = new BufferUnpacker();

        // Raw data
        $expect = array(0=>1,1=>2,2=>3);

        // Pack data
        $packed = $packer->pack($expect);

        // Unpack data
        $unpacker->reset($packed);
        $actual = $unpacker->unpack();

        $this->assertSame($expect, $actual);
    }
}
