FROM alpine:3.3

MAINTAINER Michael Laccetti <michael@laccetti.com>

ENV LUA_VERSION 5.3.2
ENV LUA_HOME /usr

ENV HAPROXY_HOME /usr
ENV HAPROXY_MAJOR 1.6
ENV HAPROXY_VERSION 1.6.5
ENV HAPROXY_MD5 5290f278c04e682e42ab71fed26fc082

# see http://sources.debian.net/src/haproxy/1.5.8-1/debian/rules/ for some helpful navigation of the possible "make" arguments
RUN set -x \
  && apk add --no-cache --virtual .build-deps \
    curl \
    gcc \
    libc-dev \
    linux-headers \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    readline-dev \
  && curl -SL "http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz" -o lua.tar.gz \
  && curl -SL "http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" -o haproxy.tar.gz \
  && echo "${HAPROXY_MD5}  haproxy.tar.gz" | md5sum -c \
  && mkdir -p /usr/src \
  && tar -xzf lua.tar.gz -C /usr/src \
  && mv "/usr/src/lua-$LUA_VERSION" /usr/src/lua \
  && rm lua.tar.gz \
  && tar -xzf haproxy.tar.gz -C /usr/src \
  && make -C /usr/src/lua INSTALL_TOP=$LUA_HOME \
    linux install \
  && mv "/usr/src/haproxy-$HAPROXY_VERSION" /usr/src/haproxy \
  && rm haproxy.tar.gz \
  && make -C /usr/src/haproxy \
    PREFIX=${HAPROXY_HOME} \
    TARGET=linux2628 \
    USE_PCRE=1 PCREDIR= \
    USE_OPENSSL=1 \
    USE_ZLIB=1 \
    USE_DL=1 \
    USE_LUA=1 \
    LUA_LIB=$LUA_HOME/lib \
    LUA_INC=$LUA_HOME/include \
    all \
    install-bin \
  && mkdir -p /etc/haproxy \
  && cp -R /usr/src/haproxy/examples/errorfiles /etc/haproxy/errors \
  && rm -rf /usr/src/haproxy \
  && runDeps="$( \
    scanelf --needed --nobanner --recursive /usr/local \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r apk info --installed \
      | sort -u \
  )" \
  && apk add --virtual .haproxy-rundeps $runDeps \
  && apk del .build-deps

COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
