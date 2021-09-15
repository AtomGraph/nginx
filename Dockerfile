FROM nginxinc/nginx-unprivileged

LABEL maintainer="martynas@atomgraph.com"

USER root

RUN apt-get update && \
    apt-get install -y iputils-ping

ENV GENERATE_SERVER_CERT=false

ENV SERVER_CERT_FILE=/etc/nginx/ssl/server.crt

ENV SERVER_KEY_FILE=/etc/nginx/ssl/server.key

ENV UPSTREAM_SERVER=

ENV TIMEOUT=10

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

COPY ./generate-x509cert.sh /usr/local/bin/generate-x509cert.sh

RUN mkdir "$(dirname "$SERVER_CERT_FILE")" && \
    mkdir "$(dirname "$SERVER_KEY_FILE")" && \
    setfacl -Rm user:101:rwx "$(dirname "$SERVER_CERT_FILE")" && \
    setfacl -Rm user:101:rwx "$(dirname "$SERVER_KEY_FILE")" && \

RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh", "/usr/local/bin/generate-x509cert.sh" ]

WORKDIR /usr/local/bin/

USER 101 # set in the base image

ENTRYPOINT ["entrypoint.sh"]