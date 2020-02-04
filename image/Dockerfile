FROM alpine:edge

EXPOSE 8080

COPY app /app
RUN set -xe \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ openconnect expect privoxy runit\
    && touch /mnt/vars.config \
    && find /app -name run | xargs chmod u+x
CMD ["runsvdir", "/app"]