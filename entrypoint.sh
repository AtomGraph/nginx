#!/bin/bash

set -e

if [ -n "${SERVER_HOST}" ] ; then
    if [ -z "${TIMEOUT}" ] ; then
        echo '$TIMEOUT not set'
        exit 1
    fi

    echo "### Waiting for ${SERVER_HOST}..."

    counter="${TIMEOUT}"
    i=1

    while [ "$i" -le "$counter" ] && ! ping -c1 "${SERVER_HOST}" >/dev/null 2>&1
    do
        sleep 1 ;
        i=$(( i+1 ))
    done

    if ping -c1 "${SERVER_HOST}" >/dev/null 2>&1 ; then
        exec "$@"
    else
        echo "### ${SERVER_HOST} not responding, exiting..."
        exit 1
    fi
else
    exec "$@"
fi