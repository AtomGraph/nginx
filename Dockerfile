FROM nginx

LABEL maintainer="martynas@atomgraph.com"

RUN apt-get update && \
    apt-get install -y iputils-ping

ENV GENERATE_SERVER_CERT=false

ENV SERVER_CERT_DIR=/etc/nginx/ssl/

ENV SERVER_CERT_FILE=/etc/nginx/ssl/server.crt

ENV SERVER_CERT_KEY=/etc/nginx/ssl/server.key

ENV UPSTREAM_SERVER=

ENV TIMEOUT=10

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]