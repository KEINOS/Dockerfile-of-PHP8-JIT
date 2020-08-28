<?php declare(strict_types=1);

require_once(__DIR__ . '/../vendor/autoload.php');

use PHPUnit\Framework\TestCase;

/**
 * https://wiki.php.net/rfc/named_params
 */
final class NamedArgumentsTest extends TestCase
{
    public function sample(string $arg1, string $arg2)
    {
        return "${arg2}${arg1}";
    }

    public function testOrdinaryWay(): void
    {
        $actual = $this->sample('foo', 'bar');
        $expect = 'barfoo';

        $this->assertSame($expect, $actual);
    }

    public function testNewStyle(): void
    {
        $actual = $this->sample(arg1: 'foo', arg2: 'bar');
        $expect = 'barfoo';

        $actual = $this->sample(arg2: 'bar', arg1: 'foo');
        $expect = 'barfoo';

        $this->assertSame($expect, $actual);
    }
}
