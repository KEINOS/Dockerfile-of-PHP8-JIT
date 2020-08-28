<?php declare(strict_types=1);

require_once(__DIR__ . '/../vendor/autoload.php');

use PHPUnit\Framework\TestCase;

final class YamlViaPeclTest extends TestCase
{
    public function testRegularYaml(): void
    {
        // Indented HereDoc is supported since PHP 7.3
        // https://wiki.php.net/rfc/flexible_heredoc_nowdoc_syntaxes
        $yaml = <<<EOD
        ---
        invoice: 34843
        date: "2001-01-23"
        bill-to: &id001
          given: Chris
          family: Dumars
          address:
            lines: |-
              458 Walkman Dr.
                      Suite #292
            city: Royal Oak
            state: MI
            postal: 48046
        ship-to: *id001
        product:
        - sku: BL394D
          quantity: 4
          description: Basketball
          price: 450
        - sku: BL4438H
          quantity: 1
          description: Super Hoop
          price: 2392
        tax: 251.420000
        total: 4443.520000
        comments: Late afternoon is best. Backup contact is Nancy Billsmer @ 338-4338.
        ...
        EOD;

        $parsed = yaml_parse($yaml);
        $actual = json_encode($parsed);
        $expect = '{"invoice":34843,"date":"2001-01-23","bill-to":{"given":"Chris","family":"Dumars","address":{"lines":"458 Walkman Dr.\n        Suite #292","city":"Royal Oak","state":"MI","postal":48046}},"ship-to":{"given":"Chris","family":"Dumars","address":{"lines":"458 Walkman Dr.\n        Suite #292","city":"Royal Oak","state":"MI","postal":48046}},"product":[{"sku":"BL394D","quantity":4,"description":"Basketball","price":450},{"sku":"BL4438H","quantity":1,"description":"Super Hoop","price":2392}],"tax":251.42,"total":4443.52,"comments":"Late afternoon is best. Backup contact is Nancy Billsmer @ 338-4338."}';

        $this->assertSame($expect, $actual);
    }
}
