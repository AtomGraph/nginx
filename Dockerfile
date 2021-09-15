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

RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y acl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /etc/nginx/ssl && \
    setfacl -Rm user:nginx:rwx /etc/nginx/ssl

RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh", "/usr/local/bin/generate-x509cert.sh" ]

WORKDIR /usr/local/bin/

USER nginx

ENTRYPOINT ["entrypoint.sh"]