#!/bin/bash

set -e

# if server's SSL certificates do not exist (e.g. not mounted), generate them
# https://community.letsencrypt.org/t/cry-for-help-windows-tomcat-ssl-lets-encrypt/22902/4

if [ "$GENERATE_SERVER_CERT" = "true" ] && [ ! -f "$SERVER_CERT_FILE" ]; then
    if [ -z "${HOST}" ] ; then
        echo '$HOST not set'
        exit 1
    fi

    if [ ! -d "$SERVER_CERT_DIR" ]; then
        mkdir -p "$SERVER_CERT_DIR"
    fi

    printf "\n### Generating server certificate\n"

    # crude check if the host is an IP address
    IP_ADDR_MATCH=$(echo "$HOST" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" || test $? = 1)

    if [ -n "$IP_ADDR_MATCH" ]; then
        ext="subjectAltName=IP:${HOST}" # IP address
    else
        ext="subjectAltName=DNS:${HOST}" # hostname
    fi

    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
      -keyout "$SERVER_CERT_KEY" -out "$SERVER_CERT_FILE" \
      -subj "/CN=${HOST}/OU=LinkedDataHub/O=AtomGraph/L=Copenhagen/C=DK" \
      -addext "$ext"
fi

if [ -n "${UPSTREAM_SERVER}" ] ; then
    if [ -z "${TIMEOUT}" ] ; then
        echo '$TIMEOUT not set'
        exit 1
    fi

    printf "\n### Waiting for %s...\n" "${UPSTREAM_SERVER}"

    counter="${TIMEOUT}"
    i=1

    while [ "$i" -le "$counter" ] && ! ping -c1 "${UPSTREAM_SERVER}" >/dev/null 2>&1
    do
        sleep 1 ;
        i=$(( i+1 ))
    done

    if ping -c1 "${UPSTREAM_SERVER}" >/dev/null 2>&1 ; then
        printf "\n### %s responded\n" "${UPSTREAM_SERVER}"
        exec "$@"
    else
        printf "\n### %s not responding, exiting...\n" "${UPSTREAM_SERVER}"
        exit 1
    fi
else
    exec "$@"
fi