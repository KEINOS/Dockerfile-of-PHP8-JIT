# Frequently Asked Questions

## Question #1 `Permission denied` error

- I get the below `Permission denied` error while building the Docker image from Dockerfile.

```dockerfile
FROM keinos/php8-jit:latest

RUN apk --no-cache add git
```
```shellsession
$ docker build -t test:local .
ERROR: Unable to lock database: Permission denied
ERROR: Failed to open apk database: Permission denied
```

- Answer

You need a `root` priviladge to install something. By default, for security reasons, the container runs with user `www-data`.

```dockerfile
FROM keinos/php8-jit:latest

USER root 
RUN apk --no-cache add git
```
