#!/bin/bash

docker build -t mlaccetti/haproxy-lua .
docker build -t mlaccetti/haproxy-lua:1.6-alpine .

docker push mlaccetti/haproxy-lua
docker push mlaccetti/haproxy-lua:1.6-alpine

docker pull mlaccetti/haproxy-lua
docker pull mlaccetti/haproxy-lua:1.6-alpine
