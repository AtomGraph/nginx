#!/bin/bash

set -e

if [ -n "${UPSTREAM_SERVER}" ] ; then
    if [ -z "${TIMEOUT}" ] ; then
        echo '$TIMEOUT not set'
        exit 1
    fi

    echo "### Waiting for ${UPSTREAM_SERVER}..."

    counter="${TIMEOUT}"
    i=1

    while [ "$i" -le "$counter" ] && ! ping -c1 "${UPSTREAM_SERVER}" >/dev/null 2>&1
    do
        sleep 1 ;
        i=$(( i+1 ))
    done

    if ping -c1 "${UPSTREAM_SERVER}" >/dev/null 2>&1 ; then
        echo "### ${UPSTREAM_SERVER} responded"
        exec "$@"
    else
        echo "### ${UPSTREAM_SERVER} not responding, exiting..."
        exit 1
    fi
else
    echo "### ${UPSTREAM_SERVER} not provided - waiting skipped"
    exec "$@"
fi