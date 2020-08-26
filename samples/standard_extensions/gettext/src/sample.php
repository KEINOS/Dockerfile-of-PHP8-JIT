<?php

function getTextIn(string $text, string $locale)
{
    // Set locale
    putenv("LC_ALL=${locale}");
    setlocale(LC_ALL, $locale);

    // File name of the dictionary
    $domain = "messages";

    // Bind the base dir of the dictionaries to the domain
    bindtextdomain($domain, "/app/locale/");
    // Set the default domain
    textdomain($domain);

    // Get the according text from the locale dictionary
    return gettext("greeting");
}

echo getTextIn('greeting', 'en_US'), PHP_EOL;
echo getTextIn('greeting', 'ja_JP'), PHP_EOL;
echo getTextIn('greeting', 'de_DE'), PHP_EOL; // Dictionary doesn't exist

// Output
// Hello, World!
// 世界よ、こんにちは！
// greeting
