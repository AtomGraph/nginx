FROM nginx

LABEL maintainer="martynas@atomgraph.com"

RUN apt-get update && \
    apt-get install -y iputils-ping

ENV UPSTREAM_SERVER=

ENV TIMEOUT=10

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]