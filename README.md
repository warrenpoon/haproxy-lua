# Supported tags and respective `Dockerfile` links

-	[`1.6.4-alpine`, `1.6-alpine`, `1-alpine`, `alpine` (*1.6/alpine/Dockerfile*)](https://github.com/mlaccetti/haproxy-lua/blob/master/Dockerfile)

[![](https://imagelayers.io/badge/mlaccetti/haproxy-lua:latest.svg)](https://imagelayers.io/?images=mlaccetti/haproxy-lua:latest)

# What is HAProxy?

HAProxy is a free, open source high availability solution, providing load balancing and proxying for TCP and HTTP-based applications by spreading requests across multiple servers. It is written in C and has a reputation for being fast and efficient (in terms of processor and memory usage).

> [wikipedia.org/wiki/HAProxy](https://en.wikipedia.org/wiki/HAProxy)

![logo](https://raw.githubusercontent.com/docker-library/docs/566c944ca5eb9d1947c8a2e8821f8de2b0fc144c/haproxy/logo.png)

# How to use this image

Since no two users of HAProxy are likely to configure it exactly alike, this image does not come with any default configuration.

Please refer to [upstream's excellent (and comprehensive) documentation](https://cbonte.github.io/haproxy-dconv/) on the subject of configuring HAProxy for your needs.

It is also worth checking out the [`examples/` directory from upstream](http://www.haproxy.org/git?p=haproxy-1.5.git;a=tree;f=examples).

Note: Many configuration examples propose to put `daemon` into the `global` section to run haproxy as daemon. Do **not** configure this or the Docker container will exit immediately after launching because the haproxy process would go into the background.

## Create a `Dockerfile`

```dockerfile
FROM mlaccetti/haproxy-lua:1.6
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
```

## Build the container

```console
$ docker build -t my-haproxy .
```

## Test the configuration file

```console
$ docker run -it --rm --name haproxy-syntax-check mlaccetti/haproxy-lua:1.6 haproxy -c -f /etc/haproxy/haproxy.cfg
```

## Run the container

```console
$ docker run -d --name my-running-haproxy my-haproxy
```
