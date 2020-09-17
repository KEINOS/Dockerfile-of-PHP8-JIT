# PECL for msgpack

Currently, `msgpack` extension can not be installed via `pecl` nor built from source.
Use `composer` version instead.

- [../../composer/msgpack](https://github.com/KEINOS/Dockerfile_of_PHP8-JIT/tree/php8-jit/samples/composer/msgpack)

## Error log

```shellsession
/app # docker-php-ext-pecl install msgpack
...
creating libtool
appending configuration tag "CXX" to libtool
configure: patching config.h.in
configure: creating ./config.status
config.status: creating config.h
/bin/sh /usr/src/php/php-src-master/ext/msgpack/libtool --mode=compile cc  -I. -I/usr/src/php/php-src-master/ext/msgpack -I/usr/src/php/php-src-master/ext/msgpack/include -I/usr/src/php/php-src-master/ext/msgpack/main -I/usr/src/php/php-src-master/ext/msgpack -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -DHAVE_CONFIG_H  -Wall -coverage -O0   -c /usr/src/php/php-src-master/ext/msgpack/msgpack.c -o msgpack.lo
/bin/sh /usr/src/php/php-src-master/ext/msgpack/libtool --mode=compile cc  -I. -I/usr/src/php/php-src-master/ext/msgpack -I/usr/src/php/php-src-master/ext/msgpack/include -I/usr/src/php/php-src-master/ext/msgpack/main -I/usr/src/php/php-src-master/ext/msgpack -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -DHAVE_CONFIG_H  -Wall -coverage -O0   -c /usr/src/php/php-src-master/ext/msgpack/msgpack_pack.c -o msgpack_pack.lo
mkdir .libs
 cc -I. -I/usr/src/php/php-src-master/ext/msgpack -I/usr/src/php/php-src-master/ext/msgpack/include -I/usr/src/php/php-src-master/ext/msgpack/main -I/usr/src/php/php-src-master/ext/msgpack -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -DHAVE_CONFIG_H -Wall -coverage -O0 -c /usr/src/php/php-src-master/ext/msgpack/msgpack_pack.c  -fPIC -DPIC -o .libs/msgpack_pack.o
 cc -I. -I/usr/src/php/php-src-master/ext/msgpack -I/usr/src/php/php-src-master/ext/msgpack/include -I/usr/src/php/php-src-master/ext/msgpack/main -I/usr/src/php/php-src-master/ext/msgpack -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -DHAVE_CONFIG_H -Wall -coverage -O0 -c /usr/src/php/php-src-master/ext/msgpack/msgpack.c  -fPIC -DPIC -o .libs/msgpack.o
/usr/src/php/php-src-master/ext/msgpack/msgpack_pack.c: In function 'msgpack_serialize_array':
/usr/src/php/php-src-master/ext/msgpack/msgpack_pack.c:226:59: warning: passing argument 1 of 'val->value.obj->handlers->get_properties_for' from incompatible pointer type [-Wincompatible-pointer-types]
  226 |             ht = Z_OBJ_HANDLER_P(val, get_properties_for)(val, ZEND_PROP_PURPOSE_ARRAY_CAST);
      |                                                           ^~~
      |                                                           |
      |                                                           zval * {aka struct _zval_struct *}
/usr/src/php/php-src-master/ext/msgpack/msgpack_pack.c:226:59: note: expected 'zend_object *' {aka 'struct _zend_object *'} but argument is of type 'zval *' {aka 'struct _zval_struct *'}
/usr/src/php/php-src-master/ext/msgpack/msgpack_pack.c: In function 'msgpack_serialize_object':
/usr/src/php/php-src-master/ext/msgpack/msgpack_pack.c:412:20: warning: implicit declaration of function 'call_user_function_ex'; did you mean 'call_user_function'? [-Wimplicit-function-declaration]
  412 |         if ((res = call_user_function_ex(CG(function_table), val_noref, &fname, &retval, 0, 0, 1, NULL)) == SUCCESS) {
      |                    ^~~~~~~~~~~~~~~~~~~~~
      |                    call_user_function
In file included from /usr/src/php/php-src-master/ext/msgpack/msgpack.c:18:
/usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.h:83:44: warning: 'template_data' defined but not used [-Wunused-function]
   83 | #define msgpack_unpack_func(ret, name) ret template ## name
      |                                            ^~~~~~~~
/usr/src/php/php-src-master/ext/msgpack/msgpack/unpack_template.h:88:1: note: in expansion of macro 'msgpack_unpack_func'
   88 | msgpack_unpack_func(msgpack_unpack_object, _data)(msgpack_unpack_struct(_context)* ctx)
      | ^~~~~~~~~~~~~~~~~~~
/bin/sh /usr/src/php/php-src-master/ext/msgpack/libtool --mode=compile cc  -I. -I/usr/src/php/php-src-master/ext/msgpack -I/usr/src/php/php-src-master/ext/msgpack/include -I/usr/src/php/php-src-master/ext/msgpack/main -I/usr/src/php/php-src-master/ext/msgpack -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -DHAVE_CONFIG_H  -Wall -coverage -O0   -c /usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c -o msgpack_unpack.lo
 cc -I. -I/usr/src/php/php-src-master/ext/msgpack -I/usr/src/php/php-src-master/ext/msgpack/include -I/usr/src/php/php-src-master/ext/msgpack/main -I/usr/src/php/php-src-master/ext/msgpack -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -DHAVE_CONFIG_H -Wall -coverage -O0 -c /usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c  -fPIC -DPIC -o .libs/msgpack_unpack.o
/bin/sh /usr/src/php/php-src-master/ext/msgpack/libtool --mode=compile cc  -I. -I/usr/src/php/php-src-master/ext/msgpack -I/usr/src/php/php-src-master/ext/msgpack/include -I/usr/src/php/php-src-master/ext/msgpack/main -I/usr/src/php/php-src-master/ext/msgpack -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -DHAVE_CONFIG_H  -Wall -coverage -O0   -c /usr/src/php/php-src-master/ext/msgpack/msgpack_class.c -o msgpack_class.lo
 cc -I. -I/usr/src/php/php-src-master/ext/msgpack -I/usr/src/php/php-src-master/ext/msgpack/include -I/usr/src/php/php-src-master/ext/msgpack/main -I/usr/src/php/php-src-master/ext/msgpack -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -DHAVE_CONFIG_H -Wall -coverage -O0 -c /usr/src/php/php-src-master/ext/msgpack/msgpack_class.c  -fPIC -DPIC -o .libs/msgpack_class.o
/usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c: In function 'msgpack_unserialize_class':
/usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c:285:28: warning: implicit declaration of function 'call_user_function_ex'; did you mean 'call_user_function'? [-Wimplicit-function-declaration]
  285 |         func_call_status = call_user_function_ex(CG(function_table), NULL, &user_func, &retval, 1, args, 0, NULL);
      |                            ^~~~~~~~~~~~~~~~~~~~~
      |                            call_user_function
In file included from /usr/local/include/php/Zend/zend.h:32,
                 from /usr/local/include/php/main/php.h:31,
                 from /usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c:1:
/usr/local/include/php/Zend/zend_string.h:60:31: warning: passing argument 2 of 'php_store_class_name' from incompatible pointer type [-Wincompatible-pointer-types]
   60 | #define ZSTR_VAL(zstr)  (zstr)->val
      |                         ~~~~~~^~~~~
      |                               |
      |                               char *
/usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c:332:45: note: in expansion of macro 'ZSTR_VAL'
  332 |         php_store_class_name(container_val, ZSTR_VAL(class_name), ZSTR_LEN(class_name));
      |                                             ^~~~~~~~
In file included from /usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c:3:
/usr/local/include/php/ext/standard/php_incomplete_class.h:54:61: note: expected 'zend_string *' {aka 'struct _zend_string *'} but argument is of type 'char *'
   54 | PHPAPI void php_store_class_name(zval *object, zend_string *name);
      |                                                ~~~~~~~~~~~~~^~~~
/usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c:332:9: error: too many arguments to function 'php_store_class_name'
  332 |         php_store_class_name(container_val, ZSTR_VAL(class_name), ZSTR_LEN(class_name));
      |         ^~~~~~~~~~~~~~~~~~~~
In file included from /usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c:3:
/usr/local/include/php/ext/standard/php_incomplete_class.h:54:13: note: declared here
   54 | PHPAPI void php_store_class_name(zval *object, zend_string *name);
      |             ^~~~~~~~~~~~~~~~~~~~
In file included from /usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.c:7:
At top level:
/usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.h:83:44: warning: 'template_execute' defined but not used [-Wunused-function]
   83 | #define msgpack_unpack_func(ret, name) ret template ## name
      |                                            ^~~~~~~~
/usr/src/php/php-src-master/ext/msgpack/msgpack/unpack_template.h:94:1: note: in expansion of macro 'msgpack_unpack_func'
   94 | msgpack_unpack_func(int, _execute)(msgpack_unpack_struct(_context)* ctx, const char* data, size_t len, size_t* off)
      | ^~~~~~~~~~~~~~~~~~~
/usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.h:83:44: warning: 'template_data' defined but not used [-Wunused-function]
   83 | #define msgpack_unpack_func(ret, name) ret template ## name
      |                                            ^~~~~~~~
/usr/src/php/php-src-master/ext/msgpack/msgpack/unpack_template.h:88:1: note: in expansion of macro 'msgpack_unpack_func'
   88 | msgpack_unpack_func(msgpack_unpack_object, _data)(msgpack_unpack_struct(_context)* ctx)
      | ^~~~~~~~~~~~~~~~~~~
/usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.h:83:44: warning: 'template_init' defined but not used [-Wunused-function]
   83 | #define msgpack_unpack_func(ret, name) ret template ## name
      |                                            ^~~~~~~~
/usr/src/php/php-src-master/ext/msgpack/msgpack/unpack_template.h:67:1: note: in expansion of macro 'msgpack_unpack_func'
   67 | msgpack_unpack_func(void, _init)(msgpack_unpack_struct(_context)* ctx)
      | ^~~~~~~~~~~~~~~~~~~
make: *** [Makefile:212: msgpack_unpack.lo] Error 1
make: *** Waiting for unfinished jobs....
/usr/src/php/php-src-master/ext/msgpack/msgpack_class.c: In function 'zim_msgpack_unpacker':
/usr/src/php/php-src-master/ext/msgpack/msgpack_class.c:277:5: warning: implicit declaration of function 'call_user_function_ex'; did you mean 'call_user_function'? [-Wimplicit-function-declaration]
  277 |     call_user_function_ex(CG(function_table), return_value, &func_name, &construct_return, 1, args, 0, NULL);
      |     ^~~~~~~~~~~~~~~~~~~~~
      |     call_user_function
In file included from /usr/src/php/php-src-master/ext/msgpack/msgpack_class.c:5:
At top level:
/usr/src/php/php-src-master/ext/msgpack/msgpack_unpack.h:83:44: warning: 'template_data' defined but not used [-Wunused-function]
   83 | #define msgpack_unpack_func(ret, name) ret template ## name
      |                                            ^~~~~~~~
/usr/src/php/php-src-master/ext/msgpack/msgpack/unpack_template.h:88:1: note: in expansion of macro 'msgpack_unpack_func'
   88 | msgpack_unpack_func(msgpack_unpack_object, _data)(msgpack_unpack_struct(_context)* ctx)
      | ^~~~~~~~~~~~~~~~~~~
Error while installing package
PHP source dir deleted.
The command '/bin/sh -c apk --no-cache add msgpack-c msgpack-c-dev &&     docker-php-ext-pecl install msgpack' returned a non-zero code: 1
```
