# Unit Tests for The Built Image

```shellsession
$ docker build --no-cache -t test:local .
$ docker run --rm -v $(pwd)/tests:/app/tests test:local
...
```
