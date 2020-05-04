FROM            alpine:3.5
MAINTAINER      Codecov <enterprise@codecov.io>

RUN             apk add --no-cache --upgrade python-dev postgresql-dev openssl supervisor nginx

RUN             mkdir /config
RUN             mkdir /archive
RUN             addgroup -S application && adduser -S codecov -G application -u 501

RUN             chown -R codecov:application /config
RUN             chown -R codecov:application /bin
RUN             chown -R codecov:application /archive

VOLUME          [ "/archive" ]

USER            codecov

COPY            docker/cacert.pem /config/cacert.pem
COPY            docker/http.nginx.conf /config/http.nginx.conf
COPY            docker/https.nginx.conf /config/https.nginx.conf
COPY            docker/run /bin/run
COPY            docker/run-many /bin/run-many
COPY            docker/codecov /bin/codecov



EXPOSE          80 443
CMD             ["/bin/run", "config"]
HEALTHCHECK     CMD ["/bin/run", "check"]
