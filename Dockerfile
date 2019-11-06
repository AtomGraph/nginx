FROM nginx

LABEL maintainer="martynas@atomgraph.com"

RUN apt-get update && \
    apt-get install -y iputils-ping