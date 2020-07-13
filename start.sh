#!/bin/bash
docker run -v $pwd\vars.config:/mnt/vars.config --cap-add=NET_ADMIN -p 8080:8080 -it ncbrj/dmr-vpn