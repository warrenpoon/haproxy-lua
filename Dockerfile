FROM alpine:3.3

MAINTAINER Michael Laccetti <michael@laccetti.com>

# HAProxy and Lua
RUN apk add --update \
  --repository http://dl-4.alpinelinux.org/alpine/edge/testing \
  --repository http://dl-4.alpinelinux.org/alpine/edge/main \
  lua5.3 lua5.3-dev luarocks5.3 lua5.3-sec lua5.3-socket haproxy haproxy-systemd-wrapper

COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
