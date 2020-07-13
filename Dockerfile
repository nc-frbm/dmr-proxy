FROM ncbrj/dmr-proxy

EXPOSE 8080

COPY vars.config /mnt/vars.config
RUN set -xe \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ openconnect expect privoxy runit dos2unix\
	&& dos2unix /mnt/vars.config