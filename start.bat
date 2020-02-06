@echo off
title Start VPN connection and proxy
docker run -v %~dp0\vars.config:/mnt/vars.config --cap-add=NET_ADMIN -p 8888:8080 -it ncbrj/dmr-proxy
