<?php declare(strict_types=1);

require_once(__DIR__ . '/../vendor/autoload.php');

use PHPUnit\Framework\TestCase;

/**
 * RFC: Nullsafe operator
 *
 * https://wiki.php.net/rfc/nullsafe_operator
 */
final class NullSafeOperatorTest extends TestCase
{
    public function testOrdinaryWay(): void
    {
        $country = null;
        $session = new NullSafeOperatorSessionSample();

        if ($session !== null) {
            $user = $session->user;

            if ($user !== null) {
                $address = $user->getAddress();

                if ($address !== null) {
                    $country = $address->country;
                }
            }
        }
        $actual = $country;
        $expect = 'Japan';

        $this->assertSame($expect, $actual);
    }

    public function testNewStyle(): void
    {
        $session = new NullSafeOperatorSessionSample();
        $country = $session?->user?->getAddress()?->country;
        $actual  = $country;
        $expect  = 'Japan';

        $this->assertSame($expect, $actual);
    }
}

class NullSafeOperatorSessionSample
{
    public $user;

    public function __construct()
    {
        $this->user = new NullSafeOperatorUserSample();
    }
}

class NullSafeOperatorUserSample
{
    public function getAddress()
    {
        return new NullSafeOperatorAddressSample();
    }
}

class NullSafeOperatorAddressSample
{
    public $country;

    public function __construct()
    {
        $this->country = 'Japan';
    }
}
