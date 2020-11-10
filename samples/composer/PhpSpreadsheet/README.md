# Sample Usage of PhpSpreadsheet

> [PhpSpreadsheet](https://github.com/PHPOffice/PhpSpreadsheet) is a library written in pure PHP and offers a set of classes that allow you to read and write various spreadsheet file-formats such as Excel and LibreOffice Calc.

This sample works on a PHP built-in web server over Docker. It downloads the [PhpSpreadsheet](https://github.com/PHPOffice/PhpSpreadsheet) via Composer with the [samples](https://github.com/PHPOffice/PhpSpreadsheet/tree/master/samples) and launches it's `index.php`.

```shellsession
$ # Build image
$ docker build -t test:local .
...
$ # Run container and launch the server
$ docker run --rm -p 9090:8080 test:local
...
$ # Then open the browser and access to http://localhost:9090/
$ # As soon as you access to the URL avobe the access log will appear.
$ # To exit press Ctrl+C
```

## Note

This sample contains the minimum requirements of the PhpSpreadsheet.

```text
Requirement check
PHP 7.2.0 ... passed
PHP extension XML ... passed
PHP extension xmlwriter ... passed
PHP extension mbstring ... passed
PHP extension ZipArchive ... passed
PHP extension GD (optional) ... passed
PHP extension dom (optional) ... passed
```

Therefore, most of the samples work but some don't. Due to the lack of package and extension which the sample requires.

If you have any packages that you think it might be good to be installed by default as a sample, feel free to PR them.
