#!/bin/bash

set -e

generate_x509cert()
{
    local host="$1"
    local out="$2"
    local keyout="$3"

    # crude check if the host is an IP address
    ip_add_match=$(echo "$host" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" || test $? = 1)

    if [ -n "$ip_add_match" ]; then
        ext="subjectAltName=IP:${host}" # IP address
    else
        ext="subjectAltName=DNS:${host}" # hostname
    fi

    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
      -out "$out" -keyout "$keyout" \
      -subj "/CN=${host}/OU=LinkedDataHub/O=AtomGraph/L=Copenhagen/C=DK" \
      -addext "$ext"
}

# if server's SSL certificates do not exist (e.g. not mounted), generate them
# https://community.letsencrypt.org/t/cry-for-help-windows-tomcat-ssl-lets-encrypt/22902/4

if [ -n "$HOST" ] && [ "$GENERATE_SERVER_CERT" = "true" ] && [ ! -f "$SERVER_CERT_FILE" ]; then
    cert_dirname=$(dirname "$SERVER_CERT_FILE")
    if [ ! -d "$cert_dirname" ]; then
        mkdir -p "$cert_dirname"
    fi
    key_dirname=$(dirname "$SERVER_KEY_FILE")
    if [ ! -d "$key_dirname" ]; then
        mkdir -p "$key_dirname"
    fi

    printf "\n### Generating server certificate\n"
    generate_x509cert "$HOST" "$SERVER_CERT_FILE" "$SERVER_KEY_FILE"
fi

if [ -n "$UPSTREAM_SERVER" ] ; then
    if [ -z "$TIMEOUT" ] ; then
        echo '$TIMEOUT not set'
        exit 1
    fi

    printf "\n### Waiting for %s...\n" "$UPSTREAM_SERVER"

    counter="$TIMEOUT"
    i=1

    while [ "$i" -le "$counter" ] && ! ping -c1 "$UPSTREAM_SERVER" >/dev/null 2>&1
    do
        sleep 1 ;
        i=$(( i+1 ))
    done

    if ping -c1 "$UPSTREAM_SERVER" >/dev/null 2>&1 ; then
        printf "\n### %s responded\n" "$UPSTREAM_SERVER"
        exec "$@"
    else
        printf "\n### %s not responding, exiting...\n" "$UPSTREAM_SERVER"
        exit 1
    fi
else
    exec "$@"
fi