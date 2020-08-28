<?php declare(strict_types=1);

require_once(__DIR__ . '/../vendor/autoload.php');

use PHPUnit\Framework\TestCase;

/**
 * https://wiki.php.net/rfc/match_expression_v2
 */
final class MatchExpressionV2Test extends TestCase
{
    public function testOrdinaryWayWithSwitch(): void
    {
        switch (1) {
            case 0:
                $result = 'Foo';
                break;
            case 1:
                $result = 'Bar';
                break;
            case 2:
                $result = 'Baz';
                break;
        }

        $actual = $result;
        $expect = 'Bar';

        $this->assertSame($expect, $actual);
    }

    public function testNewStyleWithMatch(): void
    {
        $actual = match ("1") {
            true => 'Foo',
            1    => 'Bar',
            "1"  => 'Baz',
        };
        $expect = 'Baz';

        $this->assertSame($expect, $actual);
    }
}
